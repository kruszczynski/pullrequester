# frozen_string_literal: true

module PullRequester
  class GithubParser
    Result = Struct.new(:author, :title, :url, :id)

    def self.parse(payload)
      Result.new(
        payload.dig('pull_request', 'user', 'login'),
        payload.dig('pull_request', 'title'),
        payload.dig('pull_request', 'url'),
        payload.dig('pull_request', 'id')
      )
    end
  end
end
