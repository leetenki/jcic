module Utility
  ############ utility ############
  def hankaku?(str)
    return nil if str.nil?
    # 半角のみOKなので、全角が混ざっているとfalseが返る
    unless str.to_s =~ /^[ -~｡-ﾟ]*$/
      return false
    end
  return true
  end

  def zenkaku?(str)
    return nil if str.nil?
    # 全角のみOKなので、半角が混ざっているとfalseが返る
    unless str.to_s =~/^[^ -~｡-ﾟ]*$/
      return false
    end
    return true
  end
end