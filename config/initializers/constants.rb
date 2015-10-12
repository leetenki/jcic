# -*- coding: utf-8 -*-

module Constants

  #身元保証書用 & 自動入力用
  GROUP_VISA = [:jcic]
  INDIVIDUAL_VISA = [:jcic] #:jki
  JAPAN_SIDE_COMPANY = {
    :jki => {
      :company_name => "株式会社ジェイ・ケイ・アイ",
      :code => "0712-001",
      :phone => "03-3835-1195",
      :chief => "申宏伟",
      :signature_1 => "jki_signature1.png",
      :signature_2 => "jki_signature2.png",
      :address_1 => "〒110-0015東京都台東区東上野2-20-9",
      :address_2 => "オルガンビル 3F",
    },
    :jcic => {
      :company_name => "クレーンインターナショナル株式会社",
      :code => "0509-003",
      :phone => "03-3470-6851",
      :chief => "東木慶新",
      :signature_1 => "jcic_signature1.png",
      :signature_2 => "jcic_signature2.png",
      :address_1 => "〒106-0032東京都港区六本⽊7-18-5",
      :address_2 => "ソフイアビル 212号室",
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
  EDITABLE_MIN = 30
  PAGENATION_COUNT = 100
end