require_relative 'test_helper'
require_relative '../lib/headcount_analyst'

class HeadcountAnalystTest < Minitest::Test

  def setup
    @dr = DistrictRepository.new(load_data)
    load_data = ({:enrollment =>
                        {:kindergarten =>
                          "./data/Kindergartners in full-day program.csv"}
                        })
    @ha = HeadcountAnalyst.new(@dr)
  end

  def test_it_exisit
    assert_instance_of HeadcountAnalyst,@ha
  end

  def test_enrollment_analysis_basics
    skip
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)
    assert_in_delta 1.126, ha.kindergarten_participation_rate_variation("GUNNISON WATERSHED RE1J", :against => "TELLURIDE R-1"), 0.005
    assert_in_delta 0.447, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1'), 0.005
  end
end
