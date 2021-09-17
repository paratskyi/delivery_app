class MigrateIdToUuid < ActiveRecord::Migration[6.1]
  def up
    add_column :couriers, :uuid, :uuid, null: false, unique: true, default: -> { 'gen_random_uuid()' }
    add_column :packages, :uuid, :uuid, null: false, unique: true, default: -> { 'gen_random_uuid()' }

    add_column :packages, :courier_uuid, :uuid

    execute <<-SQL
      UPDATE packages SET courier_uuid = couriers.uuid
      FROM couriers WHERE packages.courier_id = couriers.id;
    SQL

    change_column_null :packages, :courier_uuid, false

    remove_column :packages, :courier_id
    rename_column :packages, :courier_uuid, :courier_id

    add_index :packages, :courier_id

    remove_column :couriers, :id
    remove_column :packages, :id
    rename_column :couriers, :uuid, :id
    rename_column :packages, :uuid, :id

    execute "ALTER TABLE couriers ADD PRIMARY KEY (id);"
    execute "ALTER TABLE packages ADD PRIMARY KEY (id);"

    add_foreign_key :packages, :couriers

    add_index :couriers, :created_at
    add_index :packages, :created_at
  end

  def down
    rename_column :couriers, :id, :uuid
    rename_column :packages, :id, :uuid
    rename_column :packages, :courier_id, :courier_uuid

    execute "ALTER TABLE couriers DROP CONSTRAINT couriers_pkey CASCADE;"
    execute "ALTER TABLE packages DROP CONSTRAINT packages_pkey CASCADE;"

    add_column :couriers, :id, :primary_key
    add_column :packages, :id, :primary_key

    add_column :packages, :courier_id, :int

    execute <<-SQL
      UPDATE packages SET courier_id = couriers.id
      FROM couriers WHERE packages.courier_uuid = couriers.uuid;
    SQL

    remove_column :packages, :courier_uuid

    remove_column :couriers, :uuid
    remove_column :packages, :uuid

    execute "ALTER TABLE couriers ADD PRIMARY KEY (id);"
    execute "ALTER TABLE packages ADD PRIMARY KEY (id);"

    add_foreign_key :packages, :couriers

    remove_index :couriers, :created_at
    remove_index :packages, :created_at
  end
end
