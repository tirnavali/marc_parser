require_relative 'marcer'
require_relative 'marc_errors'
include MarcErrors
files = []

#Empty document for marc record
doc = <<-DOC
DOC

File.open("marc-rapor.mrk").each { |line|  doc << line }

#Seperate each marc record
$splitted_docs =  doc.split("\n\n")
enum_splitted_docs =  $splitted_docs.to_enum

  # enum_splitted_docs.each do |mrk|
  #   marcer = Marcer.new(mrk)
  #   puts "File name is : "+ marcer.mrk_isbn
  #   #puts marcer.mrk_summary
  #   #puts marcer.plain_isbn
  #   puts marcer.mrk_fields_with_index
  # end
marcer = Marcer.new($splitted_docs[110])
puts marcer.find_mrk_field("=240").founded_mrk_field
puts marcer.find_mrk_field("=245").find_sub_field["$a"]

_776 = <<-TEMP
=776  0\$iPrint version:$a#{marcer.find_mrk_field("=100").find_sub_field["$a"]}
$s#{marcer.find_mrk_field("=240").find_sub_field["$a"]}
$t#{marcer.find_mrk_field("=245").find_sub_field["$a"]}
$d#{marcer.find_mrk_field("=264").find_sub_field["$a"]}
#{marcer.find_mrk_field("=264").find_sub_field["$b"]}
#{marcer.find_mrk_field("=264").find_sub_field["$c"]}
$h#{marcer.find_mrk_field("=300").find_sub_field["$a"]},
#{marcer.find_mrk_field("=300").find_sub_field["$c"]}
$k#{marcer.find_mrk_field("=490").find_sub_field["$a"]}
#{marcer.find_mrk_field("=490").find_sub_field["$v"]}
$z#{marcer.find_mrk_field("=020").find_sub_field["$a"]}
TEMP
puts _776.gsub(/\n/, "")