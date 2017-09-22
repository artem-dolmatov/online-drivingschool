class CreateUserAuthTokens < ActiveRecord::Migration
  def change
    create_table :user_auth_tokens do |t|
      t.references :user, index: true, foreign_key: true
      t.string :devise
      t.string :devise_token
      t.string :devise_type
      t.string :auth_token
      t.integer :notify
      t.datetime :expiration_date

      t.timestamps null: false
    end
  end
end
