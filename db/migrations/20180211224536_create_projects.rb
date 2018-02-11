# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:projects) do
      primary_key :id
      String :name, null: false
      String :uuid, null: false
    end
  end
end
