# frozen_string_literal: true

require './app/parsers/github_parser'
require './app/notifiers/slack_notifier'

module PullRequester
  class WebhookAction
    Result = Struct.new(:project)
    def initialize(storage, project_uuid, payload)
      @storage = storage
      @project_uuid = project_uuid
      @payload = GithubParser.parse(payload)
    end

    def call
      project = @storage.find_project_by_uuid(@project_uuid)
      reviewers = @storage.find_reviewers_for_project(project[:id])
      notifiable_reviewers = reviewers.exclude(github_name: @payload.author)
      notifiable_reviewers.each do |reviewer|
        send_slack_notification(reviewer)
      end
      Result.new(@project)
    end

    private

    def send_slack_notification(reviewer)
      SlackNotifier.new(reviewer[:slack_name]).pull_request_created(
        title: @payload.title,
        url: @payload.url,
        author: @payload.author
      )
    end
  end
end
