# frozen_string_literal: true

class CreateFrontEndBuildsCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :front_end_builds_companies, if_not_exists: true do |t|
      t.references :app, null: false, foreign_key: {to_table: :front_end_builds_apps}
      t.string :name, null: false
      t.string :branch, null: false

      t.timestamps
    end

    add_index :front_end_builds_companies, %i[app_id name], unique: true, if_not_exists: true
  end
end
