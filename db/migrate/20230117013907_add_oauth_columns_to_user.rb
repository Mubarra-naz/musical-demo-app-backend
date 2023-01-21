class AddOauthColumnsToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :provider, :string, null: false, default: "app"
  end
end
