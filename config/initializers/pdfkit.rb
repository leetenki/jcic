PDFKit.configure do |config|
#  config.wkhtmltopdf = `which wkhtmltopdf`.to_s.strip
  config.default_options = {
    :encoding => "UTF-8",
    :page_size => "A4",
    :margin_top => "0.5in",
    :margin_right => "0.6in",
    :margin_left => "0.6in",
    :margin_bottom => "0.5in",
    :disable_smart_shrinking => false,
    :quiet => true,
    :page_size => 'Letter',
  }
end