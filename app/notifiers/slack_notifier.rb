# frozen_string_literal: true

require 'slack-ruby-client'
require 'pry'

module PullRequester
  class SlackNotifier
    def initialize(username)
      @username = username
      @client = Slack::Web::Client.new(token: ENV.fetch("SLACK_BOT_TOKEN"))
    end

    def pull_request_created(title:, url:, author:)
      message = "#{author} posted a new pull request *#{title}*."\
                " Review it here: #{url}"
      post_message(message)
    end

    private

    def post_message(text)
      @client.chat_postMessage(
        channel: "@#{@username}",
        text: text,
        as_user: true
      )
    end
  end
end
