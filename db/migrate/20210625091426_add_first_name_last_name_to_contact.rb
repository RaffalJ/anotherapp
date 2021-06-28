class AddFirstNameLastNameToContact < ActiveRecord::Migration[6.1]
  def change
    add_column :contacts, :firstname, :string
    add_column :contacts, :lastname, :string
  end
end
