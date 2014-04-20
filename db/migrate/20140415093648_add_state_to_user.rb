class AddStateToUser < ActiveRecord::Migration
  def change
    add_column :users, :activated_state, :boolean, default: false
  end
end
