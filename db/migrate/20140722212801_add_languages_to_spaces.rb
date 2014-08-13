class AddLanguagesToSpaces < ActiveRecord::Migration
  def change
    add_column :spaces, :languages, :integer
  end
end
