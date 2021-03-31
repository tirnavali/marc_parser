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
marcer = Marcer.new($splitted_docs[56])
# puts marcer.mrk_fields_with_index
# puts marcer.mrk_fields_with_index["=100"]
enum_index = marcer.mrk_fields_with_index.to_enum

# node = m.mrk_fields_with_index["=100"]
# head = m.mrk_fields_with_index
def find_mrk_field(field)
  marcer = Marcer.new($splitted_docs[11])
  if marcer.mrk_fields_to_a.include? field
    head_index_in_array = marcer.mrk_fields_to_a.index(field)
    #puts "head_index_in_array: #{head_index_in_array}"
    tail = marcer.mrk_fields_to_a[head_index_in_array+1]
    tail_mrk_index = marcer.mrk_fields_with_index[tail]
    head_mrk_index = marcer.mrk_fields_with_index[field]
    #puts "head_mrk_index : #{head_mrk_index} - tail_mrk_index:  #{tail_mrk_index}"
    field_length = tail_mrk_index - head_mrk_index
    marcer.mrk_file[head_mrk_index, field_length]

    #
    # if not found return "" -> String
  else
    raise MarcFieldDoNotExist
  end
end

#Usage
#   @param 1 = String
#   find_sub_field("$a") -> "some string"
#
#
def find_sub_field(sub_field)
  puts sub_field.size
  hash_list = Hash.new
  result_hash = Hash.new
  indexes = sub_field.scan /\$[a-z]/
  indexes.each do |i|
    #puts "i is : #{i}"
    hash_list[i] = sub_field.index(i)

  end
  puts hash_list
  hash_list.each_with_index do |(k, v), i|

    x = hash_list[hash_list.keys[i+1]] || sub_field.size
    puts "K: is #{k} V is : #{v} i is : #{i}  x is : #{x}"

    result_hash[k] = sub_field.slice(v+2,x-v-2)

  end
  result_hash
end
puts find_mrk_field "=245"
#puts find_mrk_field("=490").gsub /\$[a-z]/, ""
#puts find_mrk_field("=490").scan /\$[a-z]/
puts find_sub_field(find_mrk_field "=245")


