require_relative '../lib/district_repository'
require 'pry'
class HeadcountAnalyst
  attr_reader :dr
  def initialize(dr)
    @dr = dr
  end

  def average_kindergarten_participation_per_district(name)
    district = @dr.find_by_name(name)
    total = district.enrollment.kindergarten_participation_by_year
                               .reduce(0) {|sum, percent| sum + percent[1]}
    average = total / district.enrollment.kindergarten_participation_by_year.length
  end

  def kindergarten_participation_rate_variation(name,data)

  end
end
