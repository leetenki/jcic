data = File.read("china_code.txt")
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

  p code, name, status, locate, memo
end
