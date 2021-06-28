class CreateAddress < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.string :city, null: false
      t.string :street
      t.integer :street_number
      t.references :contact, index: true

      t.timestamps
    end
  end
end
