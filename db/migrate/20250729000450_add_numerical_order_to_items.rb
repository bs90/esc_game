class AddNumericalOrderToItems < ActiveRecord::Migration[8.0]
  def change
    add_column :items, :numerical_order, :integer
  end
end
