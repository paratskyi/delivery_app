class AddValueAssignedToDeliveryStatusType < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL
      ALTER TYPE delivery_status ADD VALUE 'assigned';
    SQL
  end

  def down
    execute <<-SQL
      CREATE TYPE delivery_status_new AS ENUM ('new', 'processing', 'delivered', 'cancelled');

      UPDATE packages
      SET delivery_status = 'processing'
      WHERE delivery_status = 'assigned';

      ALTER TABLE packages ALTER COLUMN delivery_status DROP DEFAULT;

      ALTER TABLE packages  
      ALTER COLUMN delivery_status TYPE delivery_status_new
      USING delivery_status::text::delivery_status_new;

      DROP TYPE delivery_status;
      ALTER TYPE delivery_status_new RENAME TO delivery_status;
    
      ALTER TABLE packages ALTER COLUMN delivery_status SET DEFAULT 'new'
    SQL
  end
end
