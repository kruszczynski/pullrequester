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

    def find_project_by_uuid(uuid)
      @db[:projects].where(uuid: uuid).first
    end

    def find_reviewers_for_project(project_id)
      @db[:reviewers].where(project_id: project_id)
    end
  end
end
