class AddFlightToProject < ActiveRecord::Migration
  def change
    add_column :projects, :japan_airport, :string
    add_column :projects, :flight_name, :string
    add_column :projects, :china_airport, :string
    add_column :projects, :departure_time, :time
    add_column :projects, :arrival_time, :time

    add_column :projects, :in_charge_person, :string
    add_column :projects, :in_charge_phone, :string
  end
end
