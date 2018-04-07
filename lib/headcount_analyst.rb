require_relative '../lib/district_repository'
require 'pry'

class HeadcountAnalyst
  include Parser

  attr_reader :dr

  def initialize(dr)
    @dr = dr
  end

  def average_kindergarten_participation_per_district(name)
    district = @dr.find_by_name(name)

    total = district.enrollment.kindergarten_participation_by_year
                      .reduce(0) {|sum, percent| sum + percent[1]}

    average = total / district.enrollment.kindergarten_participation_by_year.length
    
    convert_to_three_decimals(average)
  end

  def kindergarten_participation_rate_variation(name,data)
    district_1 = average_kindergarten_participation_per_district(name)
    district_2 = average_kindergarten_participation_per_district(data[:against])
    variation_rate = district_1 / district_2
    convert_to_three_decimals(variation_rate)
  end
end
