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
  :password => "1234567890",
  :password_backup => "1234567890",
  :company_name => "飞鹤国际旅行社",
  :person_name => "李庆新",
  :telephone => "08036991566",
);

Trader.create(
  :account => "leetenki",
  :qq => "140713694",
  :email => "connect@qq.com",
  :password => "1234567890",
  :password_backup => "1234567890",
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




#init_traders
accounts = [
  {
    :company_name => "AIM大阪",
    :person_name => "赵慧-胡玉玲",
    :indivisual_price => 500,
    :group_price_indivisual => 500,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "1142900343",
    :account => "1142900343"
  },
  {
    :company_name => "HELLO 旅行",
    :person_name => "小燕子",
    :indivisual_price => 320,
    :group_price_indivisual => 320,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "1446318363",
    :account => "1446318363"
  },
  {
    :company_name => "ポニュ 旅行",
    :person_name => "李国华",
    :indivisual_price => 350,
    :group_price_indivisual => 0,
    :group_price_11_20 => 3500,
    :group_price_21_30 => 3500,
    :group_price_31_40 => 3500,
    :year_3_price => 350,
    :year_5_price => 350,
    :qq => "31851010",
    :account => "31851010"
  },
  {
    :company_name => "上海科友旅游",
    :person_name => "顾建华的儿子，顾文儿子公司",
    :indivisual_price => 300,
    :group_price_indivisual => 300,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "馨美假期@上海科友国际部 (980343466)",
    :account => "980343466"
  },
  {
    :company_name => "中国太和旅行社有限公司",
    :person_name => "太和陈",
    :indivisual_price => 500,
    :group_price_indivisual => 500,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "2055329800",
    :account => "2055329800"
  },
  {
    :company_name => "上海不夜城",
    :person_name => "张佳",
    :indivisual_price => 500,
    :group_price_indivisual => 500,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "2362594244",
    :account => "2362594244"
  },
  {
    :company_name => "江苏省中旅旅行社有限公司",
    :person_name => "张心义",
    :indivisual_price => 500,
    :group_price_indivisual => 500,
    :group_price_11_20 => 1000,
    :group_price_21_30 => 1000,
    :group_price_31_40 => 1000,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "zhangxinyi0510@qq.com/384863656",
    :account => "384863656"
  },
  {
    :company_name => "成都海外旅游有限责任公司",
    :person_name => "成都辜琴 吴俊的同事",
    :indivisual_price => 400,
    :group_price_indivisual => 0,
    :group_price_11_20 => 3000,
    :group_price_21_30 => 6000,
    :group_price_31_40 => 9000,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "辜琴 /1103749809，刘冬梅/2851382930",
    :account => "1103749809"
  },
  {
    :company_name => "新興エアサービス",
    :person_name => "颖儿",
    :indivisual_price => 500,
    :group_price_indivisual => 500,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "1245969552",
    :account => "1245969552"
  },
  {
    :company_name => "苏州中旅国际出境部",
    :person_name => "方华-彭恒",
    :indivisual_price => 500,
    :group_price_indivisual => 0,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "方华2880306123/彭恒2880306124",
    :account => "2880306123"
  },
  {
    :company_name => "苏州中旅",
    :person_name => "Jerry - Q",
    :indivisual_price => 500,
    :group_price_indivisual => 500,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "13306215799",
    :account => "13306215799"
  },
  {
    :company_name => "方方",
    :person_name => "方方的同事",
    :indivisual_price => 300,
    :group_price_indivisual => 300,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "78356336方方，1905836537方方同事",
    :account => "78356336"
  },
  {
    :company_name => "江苏国旅/中国国旅（江苏）",
    :person_name => "冯清越/程成/曹亚波部长",
    :indivisual_price => 500,
    :group_price_indivisual => 0,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "冯清越2850727580/程成2850727616/曹亚波部长2850727615",
    :account => "2850727615"
  },
  {
    :company_name => "東海旅行",
    :person_name => "东海一心/東海旅行冬冬",
    :indivisual_price => 300,
    :group_price_indivisual => 0,
    :group_price_11_20 => 5000,
    :group_price_21_30 => 5000,
    :group_price_31_40 => 5000,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "东海一心1102801844/東海旅行冬冬 1226910580",
    :account => "1226910580"
  },
  {
    :company_name => "東陽旅行",
    :person_name => "李泊瑄/刘雅琪/迟丹",
    :indivisual_price => 350,
    :group_price_indivisual => 0,
    :group_price_11_20 => 3000,
    :group_price_21_30 => 4000,
    :group_price_31_40 => 5000,
    :year_3_price => 350,
    :year_5_price => 350,
    :qq => "李泊瑄 2836075122/刘雅琪3070084256/迟丹2814031768",
    :account => "2836075122"
  },
  {
    :company_name => "苏州和平",
    :person_name => "水中莲",
    :indivisual_price => 500,
    :group_price_indivisual => 500,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "565509472",
    :account => "5655094721"
  },
  {
    :company_name => "浙江光大国际旅行",
    :person_name => "顾建华儿子顾文/老爸的公司",
    :indivisual_price => 300,
    :group_price_indivisual => 300,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "浙江光大国旅日本 黄 克侬  , 顾文/980343466",
    :account => "1171239364"
  },
  {
    :company_name => "海日",
    :person_name => "史婷",
    :indivisual_price => 500,
    :group_price_indivisual => 500,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "1261429103",
    :account => "1261429103"
  },
  {
    :company_name => "深圳机场国际旅行社",
    :person_name => "刚才电话你的需要部长，亚西亚风情",
    :indivisual_price => 500,
    :group_price_indivisual => 500,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "1977506864小志/1215560884/2732689068/19743389",
    :account => "1977506864"
  },
  {
    :company_name => "苏州文化旅行",
    :person_name => "苏州文化旅行毛丹",
    :indivisual_price => 500,
    :group_price_indivisual => 500,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "苏州文化旅行毛丹maodan0810@qq.com /1020743459",
    :account => "1020743459"
  },
  {
    :company_name => "黑龙江海外",
    :person_name => "吴泽锋",
    :indivisual_price => 500,
    :group_price_indivisual => 500,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "982906587",
    :account => "982906587"
  },
  {
    :company_name => "苏州中国国际旅行有限责任公司",
    :person_name => "缪子恺/吃亏是福/成都介绍的",
    :indivisual_price => 500,
    :group_price_indivisual => 500,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "1030307189",
    :account => "1030307189"
  },
  {
    :company_name => "苏州春秋国际旅行社有限公司",
    :person_name => "周，王含青",
    :indivisual_price => 500,
    :group_price_indivisual => 0,
    :group_price_11_20 => 3000,
    :group_price_21_30 => 6000,
    :group_price_31_40 => 9000,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "2880328281/王汉青,2880328287/周莉萍",
    :account => "2880328281"
  },
  {
    :company_name => "上海中桥国际旅行社有限公司",
    :person_name => "sky 小猪，小孙",
    :indivisual_price => 400,
    :group_price_indivisual => 350,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "263846310",
    :account => "263846310"
  },
  {
    :company_name => "中国和平国际旅游有限责任公司",
    :person_name => "杨　明/中国和平",
    :indivisual_price => 500,
    :group_price_indivisual => 500,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "杨明/838114718，立派/2563375977",
    :account => "2563375977",
    :address => "〒100027北京市朝阳区东山环北路2号南银大厦707号",
    :telephone => "TEL:010-6410-6895/5229-9943/ MOL:135-0137-8422",
  },
  {
    :company_name => "苏州康辉旅行社",
    :person_name => "小周 / 赵文玲",
    :indivisual_price => 500,
    :group_price_indivisual => 500,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "小周2355778112/赵文玲2851661529",
    :account => "2851661529"
  },
  {
    :company_name => "アイガー",
    :person_name => "顾向芳",
    :indivisual_price => 500,
    :group_price_indivisual => 500,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "顾向芳 3157606686",
    :email => "guxiangfang1010@i.softbank.jp",
    :account => "3157606686"
  },
  {
    :company_name => "上海波澜",
    :person_name => "刘波,曹玮先生介绍的,日中刘波",
    :indivisual_price => 300,
    :group_price_indivisual => 300,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "877165489/刘波，164183781/杨小姐",
    :account => "164183781"
  },
  {
    :company_name => "苏州海外旅游有限公司",
    :person_name => "苏州海外日盛假期,王雅君",
    :indivisual_price => 500,
    :group_price_indivisual => 500,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "2467552339",
    :email => "yuko_777@hotmail.com",
    :address => "中国苏州市南园北路118号天和商务中心3c座二楼",
    :account => "2467552339"
  },
  {
    :company_name => "南京东方/中国国旅（浙江）国旅浙江",
    :person_name => "Natalie/虞琴琴",
    :indivisual_price => 350,
    :group_price_indivisual => 350,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "2030077404 (东日本名义汇款进帐)/虞琴琴  1056860313",
    :account => "1056860313"
  },
  {
    :company_name => "杨军",
    :person_name => "一起一起这里那里",
    :indivisual_price => 500,
    :group_price_indivisual => 500,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "924798376",
    :account => "924798376"
  },
  {
    :company_name => "株式会社エーカ",
    :person_name => "EIKA/近藤朋子",
    :indivisual_price => 1000,
    :group_price_indivisual => 1000,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "2835963938/近藤朋子",
    :email => "tohobunka@hotmail.co.jp",
    :account => "2835963938"
  },
  {
    :company_name => "东莞康辉",
    :person_name => "成都吴俊介绍的/日韩专线/杨",
    :indivisual_price => 400,
    :group_price_indivisual => 0,
    :group_price_11_20 => 3000,
    :group_price_21_30 => 4000,
    :group_price_31_40 => 5000,
    :year_3_price => 400,
    :year_5_price => 1000,
    :qq => "杨 2830365894/368329652",
    :account => "368329652"
  },
  {
    :company_name => "苏州太湖",
    :person_name => "李培超",
    :indivisual_price => 500,
    :group_price_indivisual => 500,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "56618269",
    :account => "56618269"
  },
  {
    :company_name => "苏州国旅出境部",
    :person_name => "于政-缪子恺",
    :indivisual_price => 500,
    :group_price_indivisual => 500,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "于政1511456309",
    :account => "1511456309"
  },
  {
    :company_name => "上航国旅/上海航空",
    :person_name => "缪玮玮,緑藻头米奇(小刘)",
    :indivisual_price => 300,
    :group_price_indivisual => 0,
    :group_price_11_20 => 3000,
    :group_price_21_30 => 4000,
    :group_price_31_40 => 5000,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "曹伟:18621582683/18970202/31168733曹玮，缪玮玮3974839,小刘510516503,",
    :address => "〒200125上海市浦东南路3560号10号楼3楼,〒200120上海市浦东新区丁香路1599弄3号1002室",
    :account => "18621582683"
  },
  {
    :company_name => "中国海洋",
    :person_name => "杨彩莲/吴笑笑",
    :indivisual_price => 500,
    :group_price_indivisual => 0,
    :group_price_11_20 => 3000,
    :group_price_21_30 => 6000,
    :group_price_31_40 => 9000,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "杨彩莲139105587 / 吴笑笑2851711614",
    :account => "2851711614"
  },
  {
    :company_name => "今晚国际旅行社",
    :person_name => "徐一心",
    :indivisual_price => 300,
    :group_price_indivisual => 0,
    :group_price_11_20 => 5000,
    :group_price_21_30 => 5000,
    :group_price_31_40 => 5000,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "徐一心/1229918962",
    :account => "1229918962"
  },
  {
    :company_name => "苏州青年旅行社股份有限公司",
    :person_name => "苏州青旅李苏 - 苏州中青",
    :indivisual_price => 500,
    :group_price_indivisual => 0,
    :group_price_11_20 => 2000,
    :group_price_21_30 => 3000,
    :group_price_31_40 => 4000,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "李苏/2355524256，2355758745",
    :telephone => "李苏手机/86-512-88951081",
    :account => "2355524256"
  },
  {
    :company_name => "戴文军",
    :person_name => "戴文军",
    :indivisual_price => 500,
    :group_price_indivisual => 500,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "565509472",
    :account => "565509472"
  },
  {
    :company_name => "北京自由国旅",
    :person_name => "金艳",
    :indivisual_price => 500,
    :group_price_indivisual => 500,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "金艳/2850163750，李静/985924692",
    :account => "2850163750"
  },
  {
    :company_name => "王贞",
    :person_name => "王贞",
    :indivisual_price => 350,
    :group_price_indivisual => 0,
    :group_price_11_20 => 3000,
    :group_price_21_30 => 4000,
    :group_price_31_40 => 5000,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "王贞/412322850",
    :account => "412322850"
  },
  {
    :company_name => "成都天府",
    :person_name => "王新伦出境中心毛媚",
    :indivisual_price => 500,
    :group_price_indivisual => 500,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "毛媚/137627514",
    :account => "137627514"
  },
  {
    :company_name => "四川恒信/自由恒信—自由青旅",
    :person_name => "自由青旅/青旅日韩李静",
    :indivisual_price => 500,
    :group_price_indivisual => 500,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "李静/985924692",
    :account => "985924692"
  },
  {
    :company_name => "北京杨程国际旅行社有限公司",
    :person_name => "孙毅/王翠青/吕帅",
    :indivisual_price => 500,
    :group_price_indivisual => 500,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "孙毅/2413946163，王翠青/2853297926， 张亚莉/2853297914，吕帅/2853297919,萧然 /2853297925",
    :account => "2413946163"
  },
  {
    :company_name => "重庆光大",
    :person_name => "刘茜/恩比签证Maggie",
    :indivisual_price => 400,
    :group_price_indivisual => 0,
    :group_price_11_20 => 3000,
    :group_price_21_30 => 4000,
    :group_price_31_40 => 5000,
    :year_3_price => 500,
    :year_5_price => 500,
    :qq => "刘茜/399232881",
    :account => "399232881"
  },
  {
    :company_name => "上海建发国际旅行社有限公司",
    :person_name => "陈靖（日本部经理）",
    :indivisual_price => 500,
    :group_price_indivisual => 0,
    :group_price_11_20 => 3000,
    :group_price_21_30 => 4000,
    :group_price_31_40 => 5000,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "陈靖/83463185,陈靖手机/86-13764304872",
    :account => "13764304872"
  },
  {
    :company_name => "昆山春秋国际旅行社",
    :person_name => "张晓舟（日本部经理）",
    :indivisual_price => 500,
    :group_price_indivisual => 0,
    :group_price_11_20 => 3000,
    :group_price_21_30 => 4000,
    :group_price_31_40 => 5000,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "张晓舟/2541824545，张晓舟手机/15250221522",
    :account => "2541824545"
  },
  {
    :company_name => "南京金陵商务国际旅行社有限责任公司",
    :person_name => "江苏金陵商务/南京金陵",
    :indivisual_price => 300,
    :group_price_indivisual => 0,
    :group_price_11_20 => 2000,
    :group_price_21_30 => 3000,
    :group_price_31_40 => 4000,
    :year_3_price => 350,
    :year_5_price => 350,
    :qq => "杨曼青(课长)/2850957872，杨曼青手机/18651872927，商翠/729993666，商翠手机/13913996174,新好友(操作)/2850957869",
    :account => "2850957872"
  },
  {
    :company_name => "南京中北友好国际旅行社有限公司",
    :person_name => "申克幼，李尉（油轮/日韩事业）",
    :indivisual_price => 500,
    :group_price_indivisual => 0,
    :group_price_11_20 => 2000,
    :group_price_21_30 => 3000,
    :group_price_31_40 => 4000,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "申克幼/7409660086，申克幼手机/02585755182，李尉/2820738091，434902652@163.com",
    :account => "7409660086"
  },
  {
    :company_name => "同程国际旅行社（苏州）有限公司",
    :person_name => "苏州同程国旅/常名扬",
    :indivisual_price => 500,
    :group_price_indivisual => 500,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "常名扬/2355741553，常名扬手机/18625212772",
    :account => "18625212772"
  },
  {
    :company_name => "大通旅行社",
    :person_name => "曹玮个人",
    :indivisual_price => 300,
    :group_price_indivisual => 300,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "31168733曹玮",
    :account => "31168733"
  },
  {
    :company_name => "成都中国青年",
    :person_name => "tokyo colours",
    :indivisual_price => 500,
    :group_price_indivisual => 0,
    :group_price_11_20 => 3000,
    :group_price_21_30 => 4000,
    :group_price_31_40 => 5000,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "徐月甦173404326",
    :email => "tokyocolours@gmail.com",
    :telephone => "13709083308",
    :account => "338715516"
  },
  {
    :company_name => "北京中元",
    :person_name => "北京中元",
    :indivisual_price => 500,
    :group_price_indivisual => 0,
    :group_price_11_20 => 3000,
    :group_price_21_30 => 4000,
    :group_price_31_40 => 5000,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "unknown",
    :account => "012345678"
  },
  {
    :company_name => "新联国际",
    :person_name => "新联国际",
    :indivisual_price => 500,
    :group_price_indivisual => 0,
    :group_price_11_20 => 3000,
    :group_price_21_30 => 4000,
    :group_price_31_40 => 5000,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "unknown",
    :account => "123456789"
  },
  {
    :company_name => "沈阳青年国际",
    :person_name => "刘兴鹏/沈阳国旅",
    :indivisual_price => 500,
    :group_price_indivisual => 500,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "2626234583/金佩琦",
    :account => "2626234583"
  },
  {
    :company_name => "JSC",
    :person_name => "刘国杰/冲绳",
    :indivisual_price => 500,
    :group_price_indivisual => 500,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "3295928176/刘国华",
    :account => "3295928176"
  },
  {
    :company_name => "浙江天堂国际旅行社有限公司",
    :person_name => "卢克东-漫游之旅-龙禧/张凯旋",
    :indivisual_price => 350,
    :group_price_indivisual => 350,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "2355811052张凯旋，2355917861卢克东",
    :account => "2355917861"
  },
  {
    :company_name => "杨立",
    :person_name => "杨立",
    :indivisual_price => 500,
    :group_price_indivisual => 500,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "kayu@tcat.ne.jp",
    :email => "kayu@tcat.ne.jp",
    :account => "kayu"
  },
  {
    :company_name => "華南トラベル",
    :person_name => "老板email里面的",
    :indivisual_price => 500,
    :group_price_indivisual => 500,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "unknown",
    :account => "234567890"
  },
  {
    :company_name => "上海龙舟途逸",
    :person_name => "上海龙舟途逸",
    :indivisual_price => 400,
    :group_price_indivisual => 350,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "unknown",
    :account => "345678901"
  },
  {
    :company_name => "青岛海天国际旅行社",
    :person_name => "青岛海天国际旅行社",
    :indivisual_price => 500,
    :group_price_indivisual => 500,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 1000,
    :year_5_price => 1000,
    :qq => "unknown",
    :account => "456789012"
  },
  {
    :company_name => "山东旅行社",
    :person_name => "张璇（李超 骗子） 先付款再做电签",
    :indivisual_price => 500,
    :group_price_indivisual => 500,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 500,
    :year_5_price => 500,
    :qq => "张璇  2257098339",
    :account => "2257098339"
  },
  {
    :company_name => "青山",
    :person_name => "（李超 骗子） 先付款再做电签",
    :indivisual_price => 500,
    :group_price_indivisual => 500,
    :group_price_11_20 => 0,
    :group_price_21_30 => 0,
    :group_price_31_40 => 0,
    :year_3_price => 500,
    :year_5_price => 500,
    :qq => "2834977893",
    :account => "2834977893"
  },
 ]

accounts.each do |account|
#  account[:password_backup] = [*1..9, *'A'..'Z', *'a'..'z'].sample(8).join
  account[:password_backup] = [*1..9].sample(8).join
  account[:password] = account[:password_backup]

  Trader.create(
    :account => account[:account],
    :qq => account[:qq],
    :email => account[:email],
    :password => account[:password],
    :password_backup => account[:password_backup],
    :company_name => account[:company_name],
    :person_name => account[:person_name],
    :telephone => account[:telephone],
    :indivisual_price => account[:indivisual_price],
    :group_price_indivisual => account[:group_price_indivisual],
    :group_price_11_20 => account[:group_price_11_20],
    :group_price_21_30 => account[:group_price_21_30],
    :group_price_31_40 => account[:group_price_31_40],
    :year_3_price => account[:year_3_price],
    :year_5_price => account[:year_5_price],
  );
end



