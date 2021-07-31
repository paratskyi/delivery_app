class AddIndexToPackagesTrackingNumber < ActiveRecord::Migration[6.1]
  def change
    add_index :packages, :tracking_number, unique: true
  end
end
