class Session < ActiveRecord::Base
  def self.sweep(time = 7.days, old = 30.days)
    if time.is_a?(String)
      time = time.split.inject { |count, unit| count.to_i.send(unit) }
    end

    if old.is_a?(String)
      old = old.split.inject { |count, unit| count.to_i.send(unit) }
    end

    p "delete sessions updated before #{time.ago.to_s(:db)} OR created before #{old.ago.to_s(:db)}"
    delete_all "updated_at < '#{time.ago.to_s(:db)}' OR created_at < '#{old.ago.to_s(:db)}'"
  end
end