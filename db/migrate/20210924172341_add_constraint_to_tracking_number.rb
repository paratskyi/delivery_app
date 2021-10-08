class AddConstraintToTrackingNumber < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL
      ALTER TABLE packages ADD CONSTRAINT check_tracking_number CHECK (tracking_number SIMILAR TO '%YA[0-9]{8}AA%');
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE packages DROP CONSTRAINT check_tracking_number;
    SQL
  end
end
