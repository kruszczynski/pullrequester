# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:pull_requests) do
      primary_key :id
      foreign_key :project_id, null: false
      String :title, null: false
      String :author, null: false
      String :url, null: false
      String :remote_id, null: false
      String :number, null: false
      DateTime :notified_at, null: false
    end
  end
end
