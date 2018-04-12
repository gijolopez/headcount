require 'csv'

class StatewideTest
 attr_reader :name, :third_grade, :eighth_grade
 
  def initialize(data)
    @name = data[:name]
    @third_grade = data[:third_grade] || Hash.new
    @eighth_grade = data[:eighth_grade] || Hash.new
  end
end
