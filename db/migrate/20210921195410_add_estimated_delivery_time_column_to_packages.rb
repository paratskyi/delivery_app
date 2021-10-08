class AddEstimatedDeliveryTimeColumnToPackages < ActiveRecord::Migration[6.1]
  def up
    add_column :packages, :estimated_delivery_time, :timestamp, null: false, default: -> { "now() + '1 hour'" }
  end

  def down
    remove_column :packages, :estimated_delivery_time
  end
end
