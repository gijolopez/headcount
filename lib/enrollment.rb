require_relative 'parser'

class Enrollment
  include Parser

  attr_reader :name
  attr_accessor :kindergarten_participation,
                :high_school_graduation_rates

  def initialize(data)
    @name = data[:name]
    @kindergarten_participation = data[:kindergarten_participation] || Hash.new
    @high_school_graduation_rates = data[:high_school_graduation] || Hash.new
  end

  def kindergarten_participation_by_year
    @kindergarten_participation.reduce({}) do |key,value|
      key.merge(value.first => convert_to_three_decimals(value.last))
    end
  end

  def kindergarten_participation_in_year(year)
    kindergarten_participation_by_year[year]
  end

  def graduation_rate_by_year
    @high_school_graduation_rates.reduce({}) do |key, value|
     key.merge(value.first => convert_to_three_decimals(value.last))
   end
  end
end
