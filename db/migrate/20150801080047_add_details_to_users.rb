class AddDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :comment, :string
    add_column :users, :place, :string
  end
end
