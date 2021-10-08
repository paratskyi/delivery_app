class ChangeColumnNullForCourierIdInPackages < ActiveRecord::Migration[6.1]
  def change
    change_column_null :packages, :courier_id, true
  end
end
