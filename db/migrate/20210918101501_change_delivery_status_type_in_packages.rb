class ChangeDeliveryStatusTypeInPackages < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL
      CREATE TYPE delivery_status AS ENUM ('new', 'processing', 'delivered', 'cancelled');
    SQL
    change_table :packages do |t|
      t.remove :delivery_status
      t.column :delivery_status, :delivery_status, null: false, default: 'new'
    end
  end

  def down
    change_table :packages do |t|
      t.remove :delivery_status
      t.column :delivery_status, :boolean, default: false
    end
    execute <<-SQL
      DROP TYPE IF EXISTS delivery_status;
    SQL
  end
end

