# -*- coding: utf-8 -*-

module Constants
  VISA_TYPE_TABLE = {"individual" => "个人查证", "group" => "团体查证", "3years" => "三年(新版本)", "5years" => "五年(可免签)"}

  #身元保証書用 & 自動入力用
  GROUP_VISA = [:jtg, :jki, :jcic]
  INDIVIDUAL_VISA = [:jtg, :jki, :jcic] #:jki
  JAPAN_SIDE_COMPANY = {
    :jtg => {
      :company_name => "ジェーティージー華信株式会社",
      :site_top_name => "JTG華信",
      :logo => "",
      :code => "1102-004",
      #:phone => "090-9845-1588",
      :phone => "03-5325-6288",
      :fax => "03-5325-6689",
      :chief => "高　鵬",
      :gender => "男",
      :job => "社長",
      :country => "中国",
      :stay => "日本永住",
      :birthday => "1959年9月27日",
      :signature_1 => "jtg_signature1.png",
      :signature_2 => "jtg_signature2.png",
      :address_1 => "〒160-0023東京都新宿区西新宿7-5-6",
      :address_2 => "グリーン西新宿ビル4階",
      :bank_1 => "三井住友銀行　新宿西口支店",
      :bank_2 => "普通口座　3153626",
      :bank_3 => "ジェーティージーカシン　カブシキガイシャ",
      :bank_english_1 => "SUMITOMO MITSUI BANKING CORPORATION",
      :bank_english_2 => "Shinjuku-nishiguchi Branch",
      :bank_english_3 => "259",
      :bank_english_4 => "3153626",
      :bank_english_5 => "JTGKASHIN Co., Ltd",
      :bank_english_6 => "SMBC JP JT",
      :china_bank_1 => "交通银行 上海市西支行",
      :china_bank_2 => "6222 6201 1000 9272379",
      :china_bank_3 => "高 光兴"
    },
    :jki => {
      :company_name => "株式会社ジェイ・ケイ・アイ",
      :site_top_name => "JKI",
      :logo => "",
      :code => "0712-001",
      #:phone => "090-9845-1588",
      :phone => "03-3835-1195",
      :fax => "03-3835-1196",
      :chief => "申宏伟",
      :gender => "男",
      :job => "社長",
      :country => "中国",
      :stay => "日本永住",
      :birthday => "1965年12月1日",
      :signature_1 => "jki_signature1.png",
      :signature_2 => "jki_signature2.png",
      :address_1 => "〒110-0015東京都台東区東上野2-20-12",
      :address_2 => "ヒロビル 4F",
      :bank_1 => "",
      :bank_2 => "",
      :bank_3 => "",
      :bank_english_1 => "",
      :bank_english_2 => "",
      :bank_english_3 => "",
      :bank_english_4 => "",
      :bank_english_5 => "",
      :bank_english_6 => ""      
    },
    :jcic => {
      :company_name => "クレーンインターナショナル (株)",
      :site_top_name => "飞鹤",
      :logo => "small_jcic_logo.jpg",
      :code => "0509-003",
      :phone => "03-3470-6851",
      :fax => "03-3470-8615",
      :chief => "東木慶新",
      :gender => "男",
      :job => "社長",
      :country => "日本国籍",
      :stay => "",
      :birthday => "1952年5月18日",
      :signature_1 => "jcic_signature1.png",
      :signature_2 => "jcic_signature2.png",
      :address_1 => "〒106-0032東京都港区六本⽊7-18-5",
      :address_2 => "ソフイアビル 212号室",
      :bank_1 => "三菱東京UFJ銀行　六本木支店",
      :bank_2 => "普通口座　0685088",
      :bank_3 => "クレーンインターナショナルカブシキガイシャ",
      :bank_english_1 => "BANK OF TOKYO MITSUBISHI UFJ, LTD.",
      :bank_english_2 => "Roppongi Branch Office, Tokyo Japan",
      :bank_english_3 => "045",
      :bank_english_4 => "0685088",
      :bank_english_5 => "CRANE　INTERNATIONAL CO., LTD",
      :bank_english_6 => "BOTKJPJT"
    }
  }

  #JCICサイト上のお知らせ、緊急連絡先
  SELF_COMPANY_NAME = "飞鹤国际旅行社"
  PHONE_FOR_CONTACT = "03-3470-6851"
  FAX_FOR_CONTACT = "03-3470-8615"

  #請求書用の情報(不変)
  INVOICE_CHIEF_NAME = "東木慶新"
  INVOICE_COMPANY_NAME = "クレーンインターナショナル株式会社"
  INVOICE_COMPANY_ADDRESS_1 = "〒106-0032東京都港区六本⽊7-18-5"
  INVOICE_COMPANY_ADDRESS_2 = "ソフイアビル 212号室"
  INVOICE_COMPANY_PHONE = "03-3470-6851"
  INVOICE_COMPANY_FAX = "03-3470-8615"

  INVOICE_COMPANY_BANK_1 = "三菱東京UFJ銀行　六本木支店"
  INVOICE_COMPANY_BANK_2 = "普通口座　0685088"
  INVOICE_COMPANY_BANK_3 = "クレーンインターナショナルカブシキガイシャ"
  INVOICE_COMPANY_BANK_ENGLISH_1 = "BANK OF TOKYO MITSUBISHI UFJ, LTD."
  INVOICE_COMPANY_BANK_ENGLISH_2 = "Roppongi Branch Office, Tokyo Japan"
  INVOICE_COMPANY_BANK_ENGLISH_3 = "045"
  INVOICE_COMPANY_BANK_ENGLISH_4 = "0685088"
  INVOICE_COMPANY_BANK_ENGLISH_5 = "CRANE　INTERNATIONAL CO., LTD"
  INVOICE_COMPANY_BANK_ENGLISH_6 = "BOTKJPJT"

  LOGIN_TIMEOUT_HOUR = 24
  PAGENATION_COUNT = 10
end
