# frozen_string_literal: true

require './app/parsers/github_parser'

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

      end
      Result.new(@project)
    end
  end
end
