require 'csv'
require_relative 'district'
require_relative 'enrollment_repository'
require_relative 'parser'

class DistrictRepository
  include Parser

  attr_reader :districts

  def load_data(data)
    data_set = data[:enrollment][:kindergarten]
    process_district_data(data_set)
  end

  def process_district_data(data_set)
    contents = CSV.open(data_set, {headers: true, header_converters: :symbol})
    @districts = contents.collect do |row|
      parse_name(row)
      District.new(row)
    end
     districts.uniq! {|district| district.name}
  end

  def find_by_name(name)
    @districts.find {|district| district.name == name}
  end

  def find_all_matching(name)
    index = name.length - 1
    @districts.find_all {|district| district.name[0..index] == name[0..index]}
  end

end
