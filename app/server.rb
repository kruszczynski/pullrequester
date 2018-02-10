# frozen_string_literal: true

require 'sinatra'

module PullRequester
  class Server < Sinatra::Base
    get '/test' do
      "It works"
    end
  end
end
