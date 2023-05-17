class AddDefaultToCreditAccepted < ActiveRecord::Migration[7.0]
  def change
    change_column_default :vendors, :credit_accepted, false
  end
end
