#This Marcer class takes one parameter mrk_file must be string
#
#   m = Marcer.new(example_file)
#   m.mrk_fileds -> Array
#   m.mrl_fields_with_index -> Hash
#   =>
#
class Marcer
  attr_reader :mrk_file, :mrk_summary, :mrk_isbn, :plain_isbn, :mrk_fields_to_a, :mrk_fields_with_index
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
    #Finds marc fields in the document
    detect_marc_fields
    #@_100=

  end
  #
  # This method runs for find existing marc fields
  # in related file.
  #
  #     Marcer.new(example_file).detect_marc_fields
  #
  def detect_marc_fields
    @mrk_fields_to_a = @mrk_file.scan /\=[0-9][0-9][0-9]/
    @mrk_fields_to_a.each do  |field|
      @mrk_fields_with_index[field] = (@mrk_file.index(field))
    end
  end
end