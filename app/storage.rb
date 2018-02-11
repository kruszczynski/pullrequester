# frozen_string_literal: true

require 'sequel'
require './app/models/project'

module PullRequester
  class Storage
    def initialize(database_url)
      @db = Sequel.connect(database_url)
    end

    def all_projects
      @db[:projects].all
    end

    def find_project(uuid)
      @db[:projects].where(uuid: uuid).first
    end
  end
end
