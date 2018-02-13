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

    def find_pull_request(remote_id)
      @db[:pull_requests].where(remote_id: remote_id.to_s).first
    end

    def create_pull_request(project_id:, title:, author:, url:, remote_id:, number:, notified_at:)
      new_pull_request_id = @db[:pull_requests].insert(
        project_id: project_id,
        title: title,
        author: author,
        url: url,
        remote_id: remote_id,
        number: number,
        notified_at: notified_at
      )
      @db[:pull_requests].where(id: new_pull_request_id).first
    end
  end
end
