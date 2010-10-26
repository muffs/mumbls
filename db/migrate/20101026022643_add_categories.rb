class AddCategories < ActiveRecord::Migration  
  def self.up
    create_table :categories do |t|
      t.string :name
      t.string :type
    end
  end

  def self.down
    drop_table :categories
  end  
end