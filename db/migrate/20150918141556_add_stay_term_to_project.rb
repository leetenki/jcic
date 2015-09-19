class AddStayTermToProject < ActiveRecord::Migration
  def change
    add_column :projects, :stay_term, :integer
  end
end
