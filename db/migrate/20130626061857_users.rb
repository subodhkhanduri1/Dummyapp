class Users < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.column :username, :string, :limit => 40, :null => false
      t.column :password, :string, :limit => 80, :null => false
      t.timestamps
    end
    #User.create :username => "subodh"
  end

  #User.create :username => "subodh", :password => "subodh"
  #end

  def down
    drop_table :users
  end
end
