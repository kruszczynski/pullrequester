# frozen_string_literal: true

module PullRequester
  class GithubParser
    Result = Struct.new(:author, :title, :url, :id, :action, :number, :already_in_review?)

    def self.parse(payload)
      Result.new(
        payload.dig('pull_request', 'user', 'login'),
        payload.dig('pull_request', 'title'),
        payload.dig('pull_request', 'html_url'),
        payload.dig('pull_request', 'id'),
        payload['action'],
        payload['number'],
        payload.dig('pull_request', 'requested_reviewers').count.positive?
      )
    end
  end
end
