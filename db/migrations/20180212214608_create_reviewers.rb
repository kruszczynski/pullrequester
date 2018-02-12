# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:reviewers) do
      primary_key :id
      foreign_key :project_id
      String :email, null: false
      String :github_name, null: false
      String :slack_name, null: false
    end
  end
end
