# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Trader.create(
  :account => "admin",
  :email => "toukyouniversityoftechnology@gmail.com",
  :password => "fB3m-W52",
  :password_backup => "fB3m-W52",
  :company_name => "飞鹤国际旅行社",
  :person_name => "李庆新",
  :telephone => "08036991566",
);

Trader.create(
  :account => "140713694",
  :email => "connect@qq.com",
  :password => "q1w2e3r4",
  :password_backup => "q1w2e3r4",
  :company_name => "QQ国际旅行社",
  :person_name => "李天琦",
  :telephone => "08036991566",
);