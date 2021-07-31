class CreatePackages < ActiveRecord::Migration[6.1]
  def change
    create_table :packages do |t|
      t.string :tracking_number
      t.boolean :delivery_status
      t.references :courier, null: false, foreign_key: true

      t.timestamps
    end
  end
end
