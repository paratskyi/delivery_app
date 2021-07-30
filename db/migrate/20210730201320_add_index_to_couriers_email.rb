class AddIndexToCouriersEmail < ActiveRecord::Migration[6.1]
  def change
    add_index :couriers, :email, unique: true
  end
end
