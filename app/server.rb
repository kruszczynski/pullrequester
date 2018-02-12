# frozen_string_literal: true

require 'dotenv/load'
require 'sinatra'
require './app/storage'
require './app/actions/webhook_action'

module PullRequester
  class Server < Sinatra::Base
    set :storage, Storage.new(ENV.fetch('DATABASE_URL'))

    post '/webhooks/:uuid' do
      # we're only interested in pull request events
      return 200 unless request.env['HTTP_X_GITHUB_EVENT'] == 'pull_request'

      action = WebhookAction.new(
        settings.storage,
        params['uuid'],
        JSON.parse(request.body.read)
      )
      action.call
      200
    end
  end
end
