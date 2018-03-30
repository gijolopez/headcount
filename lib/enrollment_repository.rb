require 'csv'
require_relative 'enrollment'
require_relative 'parser'

class EnrollmentRepository

  attr_reader :enrollments

  def load_data(data)
    data_set = data[:enrollment][:kindergarten]
    process_district_data(data_set)
  end

  def process_district_data(data_set)
    contents = CSV.open(data_set, {headers: true, header_converters: :symbol})
    @enrollments = contents.collect do |row|
      parse_name(row)
      Emrollment.new(row)
    end
     enrollments.uniq! {|enroll| enroll.name}
  end
end
