require_relative 'parser'

class Enrollment
  include Parser

  attr_reader :name
  attr_accessor :kindergarten_participation

  def initialize(data)
    @name = data[:name]
    @kindergarten_participation = data[:kindergarten_participation] || Hash.new
  end

  def kindergarten_participation_by_year
    @kindergarten_participation.reduce({}) do |key,value|
      key.merge(value.first => convert_to_three_decimals(value.last))
    end
  end

  def kindergarten_participation_in_year(year)
    kindergarten_participation_by_year[year]
  end
end
