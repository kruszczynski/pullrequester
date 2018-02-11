# frozen_string_literal: true

require 'sequel'

module PullRequester
  class Storage
    def initialize(database_url)
      @db = Sequel.connect(database_url)
    end

    def all_projects
      @db[:projects].all
    end
  end
end
