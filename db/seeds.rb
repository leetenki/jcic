# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


#init and admin and trader
Trader.create(
  :account => "admin",
  :email => "toukyouniversityoftechnology@gmail.com",
  :password => "fB3m-W52",
  :password_backup => "q1w2e3r4",
  :company_name => "飞鹤国际旅行社",
  :person_name => "李庆新",
  :telephone => "08036991566",
);

Trader.create(
  :account => "leetenki",
  :qq => "140713694",
  :email => "connect@qq.com",
  :password => "q1w2e3r4",
  :password_backup => "q1w2e3r4",
  :company_name => "QQ国际旅行社",
  :person_name => "李天琦",
  :telephone => "08036991566",
);



#init china company code
data = File.read("db/china_code.txt")
data.lines.each do |line|
  items = line.split("\t");

  code = items[0].split(" ")[0]
  locate = items[2];

  if(items[1].include?("【停止】"))
    name = items[1].split("【停止】")[1]
    status = "stopped"
  else
    name = items[1]
    status = "working"
  end

  memo = nil;
  if !items[3].nil?
    memo = items[3].split("\n")[0]
  end

  CompanyCode.create(
    :name => name,
    :code => code,
    :locate => locate,
    :memo => memo,
    :status => status,
    :address => nil,
  );
end
