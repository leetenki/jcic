class Relationship < ActiveRecord::Base
  belongs_to :master, :class_name => "Trader"
  belongs_to :slave, :class_name => "Trader"
end
