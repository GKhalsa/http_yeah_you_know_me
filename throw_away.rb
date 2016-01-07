words = {}
File.open("/usr/share/dict/words") do |file|
  file.each do |line|
    words[line.strip] = true
  end
end

p words["magic"]
p words["hello"]
p words["yeah"]
p words["cawabunga"]
