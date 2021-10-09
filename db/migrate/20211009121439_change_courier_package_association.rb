class ChangeCourierPackageAssociation < ActiveRecord::Migration[6.1]
  def up
    create_table :package_assignments, id: :uuid do |t|
      t.belongs_to :courier, type: :uuid
      t.belongs_to :package, type: :uuid
      t.timestamps
    end

    execute <<-SQL
      INSERT INTO package_assignments(courier_id, package_id, created_at, updated_at)
      SELECT couriers.id AS couriers_id, packages.id AS packages_id, NOW(), NOW() 
      FROM couriers JOIN packages 
      ON couriers.id = packages.courier_id;
    SQL

    remove_reference :packages, :courier, index: true, foreign_key: true
  end

  def down
    add_reference :packages, :courier, type: :uuid, index: true, foreign_key: true

    execute <<-SQL
      UPDATE packages
      SET courier_id = package_assignments.courier_id
      FROM (SELECT package_id, courier_id FROM package_assignments) AS package_assignments
      WHERE packages.id = package_assignments.package_id;
    SQL

    drop_table :package_assignments
  end
end
