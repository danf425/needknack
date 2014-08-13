class RemoveHouseRulesFromSpaces < ActiveRecord::Migration
  def up
    remove_column :spaces, :house_rules
  end

  def down
    add_column :spaces, :house_rules, :text
  end
end
