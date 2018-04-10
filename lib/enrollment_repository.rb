require 'csv'
require_relative 'enrollment'
require_relative 'parser'

class EnrollmentRepository
  include Parser

  attr_reader :enrollments

  def load_data(data)
    @kindergarten_data_set = data[:enrollment][:kindergarten]
    @high_school_data_set = data[:enrollment][:high_school_graduation]
    @enrollments = collect_enrollments
    uniqueize_enrollments
    add_kindergarten_data_to_enrollments
    add_high_school_data_to_enrollments if @high_school_data_set
    enrollments
  end

  def collect_enrollments
    kindergarten_contents = CSV.open(@kindergarten_data_set,
      {headers: true, header_converters: :symbol})
    kindergarten_contents.collect do |row|
      parse_name(row)
      Enrollment.new({:name => row[:name]})
    end
  end

  def uniqueize_enrollments
    enrollments.uniq! do |enrollment|
      enrollment.name
    end
  end

  def add_kindergarten_data_to_enrollments
    kindergarten_contents = CSV.open(@kindergarten_data_set,
      {headers: true, header_converters: :symbol})
    kindergarten_contents.each do |row|
      parse_name(row)
      parse_timeframe(row)
      parse_data(row)
      enrollments[index_finder(row)].kindergarten_participation[row[:timeframe]] = row[:data]
    end
    enrollments
  end

  def add_high_school_data_to_enrollments
    high_school_contents = CSV.open(@high_school_data_set,
      {headers: true, header_converters: :symbol})
    high_school_contents.each do |row|
      parse_name(row)
      parse_timeframe(row)
      parse_data(row)
      enrollments[index_finder(row)].high_school_graduation_rates[row[:timeframe]] = row[:data]
    end
    enrollments
  end

  def index_finder(row)
    @enrollments.find_index {|enrollment|enrollment.name == row[:name]}
  end

  def find_by_name(name)
    @enrollments.find {|enrollment| enrollment.name == name}
  end
end
