class AddOthersToUsers < ActiveRecord::Migration
  def change

    add_column :users, :session_token, 		:string
    add_column :users, :first_name, 		:string,	null: false
    add_column :users, :last_name, 			:string,	null: false
    add_column :users, :updated_at,			:datetime,	null: false
    add_column :users, :photo_url, 			:string
    add_column :users, :avatar_file_name, 	:string
    add_column :users, :avatar_content_type,:string
    add_column :users, :avatar_file_size, 	:integer
    add_column :users, :avatar_updated_at, 	:datetime
    add_column :users, :description,		:string

#    add_column :users, :password_digest,	:string,	null: false

    add_index :users, :session_token

  end
end