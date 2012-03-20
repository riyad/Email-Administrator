class RenameForwardEmailToForwardDestinationsInEmails < ActiveRecord::Migration
  def change
    rename_column :emails, :forward_email, :forward_destinations
  end
end
