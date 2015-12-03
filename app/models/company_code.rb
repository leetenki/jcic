class CompanyCode < ActiveRecord::Base
  validates :name, :presence => true
  validates :code, :presence => true
  validates :locate, :presence => true
  validates :status, :presence => true, :inclusion => {:in => ["working", "stopped"]}

  def self.rename_doubled_company_codes
    CompanyCode.all.each do |company_code|
      match_count = 0

      CompanyCode.all.each do |compared_company_code|
        if company_code[:name] == compared_company_code[:name]
          match_count += 1
          if(match_count >= 2)
            if(match_count == 2)
              #update old company_codes
              new_name = company_code[:name] + "（１）"
              company_code.update(:name => new_name)
            end

            #update new company_codes
            new_name = compared_company_code[:name] + "（" + (match_count.to_s.ord+0xFEE0).chr + "）"
            compared_company_code.update(:name => new_name)
          end
        end
      end
    end
  end

end
