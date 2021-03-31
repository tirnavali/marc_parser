require_relative 'marc_errors'
include MarcErrors
#This Marcer class takes one parameter mrk_file must be string
#
#   m = Marcer.new(example_file)
#   m.mrk_fileds -> Array
#   m.mrl_fields_with_index -> Hash
#   =>
#
class Marcer  
  attr_reader :mrk_file, :mrk_summary, :mrk_isbn, :plain_isbn, :mrk_fields_to_a, :mrk_fields_with_index, :founded_mrk_field
  def initialize(mrk_file)
    @mrk_file = mrk_file
    #isbn marc field
    @mrk_isbn = (@mrk_file.match /\=020.*/).to_s
    #standart isbn field
    @plain_isbn = @mrk_isbn.split("$z")[1] || @mrk_isbn.split("$a")[1]
    @plain_isbn = @plain_isbn.split("$")[0] if @plain_isbn.include? "$"
    #A brief summary about file
    @mrk_summary = @mrk_file[0,200]+"..."
    #All marc fields in the document
    @mrk_fields_to_a = Array.new
    #All marc fields with index positions in the document
    @mrk_fields_with_index = Hash.new

    @founded_mrk_field = ""
    #Finds marc fields in the document
    detect_marc_fields
  end

  def find_mrk_field(field)    
    marcer = @mrk_file
    if mrk_fields_to_a.include? field
      head_index_in_array = @mrk_fields_to_a.index(field)
      #puts "head_index_in_array: #{head_index_in_array}"
      tail = @mrk_fields_to_a[head_index_in_array+1]
      tail_mrk_index = @mrk_fields_with_index[tail]
      head_mrk_index = @mrk_fields_with_index[field]
      #puts "head_mrk_index : #{head_mrk_index} - tail_mrk_index:  #{tail_mrk_index}"
      field_length = tail_mrk_index - head_mrk_index
      @founded_mrk_field = @mrk_file[head_mrk_index, field_length]
      self

      #
      # if not found return "" -> String
    else
      #raise MarcFieldDoNotExist
      @founded_mrk_field = ""
      self
    end
  end

  def find_sub_field()
    sub_field = @founded_mrk_field  
    hash_list = Hash.new
    result_hash = Hash.new
    indexes = sub_field.scan /\$[a-z]/
    indexes.each do |i|
      #puts "i is : #{i}"
      hash_list[i] = sub_field.index(i)
    end
    #puts hash_list
    hash_list.each_with_index do |(k, v), i|
      x = hash_list[hash_list.keys[i+1]] || sub_field.size
      #puts "K: is #{k} V is : #{v} i is : #{i}  x is : #{x}"
      result_hash[k] = sub_field.slice(v+2,x-v-2)
    end
    result_hash
  end
  #
  #This method runs for find existing marc fields
  #in related file.
  #
  #  Marcer.new(example_file).detect_marc_fields
  #    =>   "=100  1\$aYavuz, Turan."
  # 
  def detect_marc_fields
    @mrk_fields_to_a = @mrk_file.scan /\=[0-9][0-9][0-9]/
    @mrk_fields_to_a.each do  |field|
      @mrk_fields_with_index[field] = (@mrk_file.index(field))
    end
  end

  private :detect_marc_fields
end