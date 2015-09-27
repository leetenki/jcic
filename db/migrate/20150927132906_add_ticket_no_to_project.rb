class AddTicketNoToProject < ActiveRecord::Migration
  def change
    add_column :projects, :ticket_no, :string, :default => ""
  end
end
