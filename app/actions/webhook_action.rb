# frozen_string_literal: true

require './app/parsers/github_parser'
require './app/notifiers/slack_notifier'

module PullRequester
  class WebhookAction
    ACTIONABLE_ACTIONS = %w(opened reopened synchronize).freeze

    def initialize(storage, project_uuid, payload)
      @storage = storage
      @project_uuid = project_uuid
      @payload = GithubParser.parse(payload)
    end

    def call
      return unless actionable?
      project = @storage.find_project_by_uuid(@project_uuid)

      find_or_create_pull_request(project)
      return if recently_notified?

      reviewers = @storage.find_reviewers_for_project(project[:id])
      notifiable_reviewers = reviewers.exclude(github_name: @payload.author)
      notifiable_reviewers.each do |reviewer|
        send_slack_notification(reviewer)
      end
    end

    private

    def actionable?
      @payload.action.in?(ACTIONABLE_ACTIONS) && !@payload.already_in_review?
    end

    def find_or_create_pull_request(project)
      @pull_request = @storage.find_pull_request(@payload.id)
      return if @pull_request
      @new_pull_request = true
      @pull_request = @storage.create_pull_request(
        project_id: project[:id],
        title: @payload.title,
        author: @payload.author,
        url: @payload.url,
        remote_id: @payload.id,
        number: @payload.number,
        notified_at: Time.now
      )
    end

    def recently_notified?
      return false if @new_pull_request
      Time.now - @pull_request[:notified_at] < 1.second
    end

    def send_slack_notification(reviewer)
      SlackNotifier.new(reviewer[:slack_name]).pull_request_created(
        title: @pull_request[:title],
        url: @pull_request[:url],
        author: @pull_request[:author]
      )
    end
  end
end
