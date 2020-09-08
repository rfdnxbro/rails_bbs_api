# frozen_string_literal: true

class DeviseTokenAuthCreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table(:users) do |t|
      ## Required
      t.string :provider, null: false, default: "email"
      t.string :uid, null: false, default: ""

      ## Database authenticatable
      t.string :encrypted_password, null: false, default: ""

      ## Rememberable
      t.datetime :remember_created_at

      ## User Info
      t.string :name
      t.string :email

      ## Tokens
      t.json :tokens

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, %i[uid provider], unique: true
  end
end
