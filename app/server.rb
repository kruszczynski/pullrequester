# frozen_string_literal: true

require 'dotenv/load'
require 'sinatra'
require './app/storage'

module PullRequester
  class Server < Sinatra::Base
    set :storage, Storage.new(ENV.fetch('DATABASE_URL'))

    post '/webhooks/:uuid' do
      project = settings.storage.find_project(params['uuid'])
      return 200 unless request.env['HTTP_X_GITHUB_EVENT'] == 'pull_request'
      project.to_s
    end
  end
end
