require_relative 'test_helper'
require_relative '../lib/headcount_analyst'

class HeadcountAnalystTest < Minitest::Test

  def setup
    @dr = DistrictRepository.new
    data = ({:enrollment =>
                        {:kindergarten =>
                          "./data/Kindergartners in full-day program.csv"}
                        })
    @dr.load_data(data)
    @ha = HeadcountAnalyst.new(@dr)
  end

  def test_it_exisit
    assert_instance_of HeadcountAnalyst, @ha
    assert_instance_of DistrictRepository, @dr
  end

  def test_kindergarten_participation_rate_per_district
    average = @ha.average_kindergarten_participation_per_district("ACADEMY 20")
    assert_equal 0.406, average
  end

  # def test_multipal_kindergarten_participation_rate_per_district
  #   average = @ha.average_kindergarten_participation_per_district("ARCHULETA")
  #   assert_equal 0.406, average
  # end

  def test_enrollment_analysis_basics

    assert_equal 1.126, @ha.kindergarten_participation_rate_variation("GUNNISON WATERSHED RE1J", :against => "TELLURIDE R-1")
    assert_equal 0.446, @ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1')
  end
end
