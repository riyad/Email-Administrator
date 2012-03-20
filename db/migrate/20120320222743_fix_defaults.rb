class FixDefaults < ActiveRecord::Migration
  def change
    change_column :domains, :name,        :string,  :null => false

    change_column :emails, :email,        :string,  :null => false
    change_column :emails, :can_receive,  :boolean, :null => false, :default => false
    change_column :emails, :active,       :boolean, :null => false, :default => true
    change_column :emails, :last_activity_on, :date,                :default => nil
    change_column :emails, :admin,        :boolean, :null => false, :default => false
    change_column :emails, :can_send,     :boolean, :null => false, :default => true
  end
end
