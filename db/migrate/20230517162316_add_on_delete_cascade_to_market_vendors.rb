class AddOnDeleteCascadeToMarketVendors < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :market_vendors, :vendors
    add_foreign_key :market_vendors, :vendors, on_delete: :cascade
  end
end
