require 'csv'
require_relative 'statewide_test'
require_relative 'parser'

class StatewideTestRepository
  include Parser

  attr_reader :tests

  def load_data(data)
    @third_grade_data   = data[:statewide_testing][:third_grade]
    @eighth_grade_data  = data[:statewide_testing][:eighth_grade]
    @math               = data[:statewide_testing][:math]
    @reading            = data[:statewide_testing][:reading]
    @writing            = data[:statewide_testing][:writing]
    @tests              = collect_statewide_tests(@third_grade_data)
    add_data
  end

  def add_data
    uniqueize_statewide_tests
    add_third_grade_data_to_tests
    add_eighth_grade_data_to_tests
    add_math_data_to_race_data
    add_reading_data_to_race_data
    add_writing_data_to_race_data
  end

  def collect_statewide_tests(contents)
    contents = CSV.open(@third_grade_data,
                       {headers: true, header_converters: :symbol})
    contents.collect do |row|
      parse_name(row)
      StatewideTest.new({:name => row[:name]})
   end
  end

  def uniqueize_statewide_tests
    tests.uniq! do |test|
      test.name
    end
  end

  def add_third_grade_data_to_tests
    third_grade_contents = CSV.open(@third_grade_data,
                                  {headers: true, header_converters: :symbol})
    third_grade_contents.each do |row|
      parse_name(row)
      parse_timeframe(row)
      parse_data(row)
    end
   tests
  end

  def add_eighth_grade_data_to_tests
    eighth_grade_contents = CSV.open(@eighth_grade_data,
                                    {headers: true, header_converters: :symbol})
    eighth_grade_contents.each do |row|
      parse_name(row)
      parse_timeframe(row)
      parse_data(row)
    end
    tests
  end

  def add_math_data_to_race_data
    math_contents = CSV.open(@math,
                      {headers: true, header_converters: :symbol})
    math_contents.each do |row|
      parse_name(row)
      parse_timeframe(row)
      parse_data(row)
    end
    tests
  end

  def add_reading_data_to_race_data
    reading_contents = CSV.open(@reading,
                                {headers: true, header_converters: :symbol})
    reading_contents.each do |row|
      parse_name(row)
      parse_timeframe(row)
      parse_data(row)
    end
    tests
  end

  def add_writing_data_to_race_data
    writing_contents = CSV.open(@writing,
                                {headers: true, header_converters: :symbol})
    writing_contents.each do |row|
      parse_name(row)
      parse_timeframe(row)
      parse_data(row)
    end
    tests
  end

end
