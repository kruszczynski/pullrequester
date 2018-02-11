# frozen_string_literal: true

require 'dotenv/load'
require 'sinatra'
require 'sequel'
require './app/storage'

module PullRequester
  class Server < Sinatra::Base
    set :storage, Storage.new(ENV.fetch('DATABASE_URL'))

    get '/test' do
      settings.storage.all_projects.to_s
    end
  end
end
