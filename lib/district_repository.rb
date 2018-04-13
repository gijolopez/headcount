require 'csv'
require_relative 'district'
require_relative 'enrollment_repository'
require_relative 'statewide_test_repository'
require_relative 'parser'

class DistrictRepository
  include Parser

  attr_reader :districts, :enrollments

  def load_data(data)
    data_set = data[:enrollment][:kindergarten]
    process_district_data(data_set)
    if data[:enrollment]
      load_enrollments(data)
    end
    if data[:statewide_testing]
      load_state_testing(data)
    end
  end

  def process_district_data(data_set)
    contents = CSV.open(data_set,
      {headers: true, header_converters: :symbol})
    @districts = contents.collect do |row|
      parse_name(row)
      District.new(row)
    end
     districts.uniq! {|district| district.name}
  end

  def load_enrollments(data)
    er = EnrollmentRepository.new
    @enrollments = er.load_data(data)
    add_enrollment_to_district
  end

  def load_state_testing(data)
    str = StatewideTestRepository.new
    @statewide_tests = str.load_data(data)
    add_statewide_tests_to_district
  end

  def add_enrollment_to_district
    @districts.each_with_index do |district, index|
      district.enrollment = @enrollments[index]
    end
  end

  def add_statewide_tests_to_district
   @districts.each_with_index do |district, index|
     district.statewide_test = @statewide_tests[index]
   end
 end

  def find_by_name(name)
    @districts.find {|district| district.name == name}
  end

  def find_all_matching(name)
    index = name.length - 1
    @districts.find_all {|district| district.name[0..index] == name[0..index]}
  end
end
