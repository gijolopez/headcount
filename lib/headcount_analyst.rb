require_relative '../lib/district_repository'

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

  def kindergarten_participation_rate_variation(name, data)
    district_1 = average_kindergarten_participation_per_district(name)
    district_2 = average_kindergarten_participation_per_district(data[:against])
    variation_rate = district_1 / district_2
    convert_to_three_decimals(variation_rate)
  end

  def kindergarten_participation_rate_variation_trend(name, data)
    district_1 = @dr.find_by_name(name)
    district_1_data = district_1.enrollment.kindergarten_participation_by_year

    district_2 = @dr.find_by_name(data[:against])
    district_2_data = district_2.enrollment.kindergarten_participation_by_year

    variation = district_1_data.merge(district_2_data) do |key, oldval, newval|
    variation_trend = oldval / newval
    convert_to_three_decimals(variation_trend)
   end
  end

  def average_high_school_graduation_per_district(name)
    district = @dr.find_by_name(name)

    total = district.enrollment.graduation_rate_by_year
                      .reduce(0) {|sum, percent| sum + percent[1]}

    average = total / district.enrollment.graduation_rate_by_year.length

    convert_to_three_decimals(average)
  end

  def high_school_graduation_rate_variation(name, data)
    district_1 = average_high_school_graduation_per_district(name)
    district_2 = average_high_school_graduation_per_district(data[:against])
    variation_rate = district_1 / district_2
    convert_to_three_decimals(variation_rate)
  end

  def kindergarten_participation_against_high_school_graduation(name)
    variation_rate = kindergarten_participation_rate_variation(name, :against => 'COLORADO') / high_school_graduation_rate_variation(name, :against => 'COLORADO')
    convert_to_three_decimals(variation_rate)
  end
end
