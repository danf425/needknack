class RemoveResidenceTypeFromSpaces < ActiveRecord::Migration
  def up
    remove_column :spaces, :residence_type
  end

  def down
    add_column :spaces, :residence_type, :string
  end
end
