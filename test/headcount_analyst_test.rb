require_relative 'test_helper'
require_relative '../lib/headcount_analyst'

class HeadcountAnalystTest < Minitest::Test

  def setup
    @dr = DistrictRepository.new
    @dr.load_data({
                  :enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv",
                    :high_school_graduation => "./data/High school graduation rates.csv"
                  },
                  :statewide_testing => {
                    :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                    :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                    :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                    :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                    :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                  }
                }
                )
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

  def test_kindergarten_participation_rate_variation_compared_to_statewide_avg
    assert_equal 0.766, @ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
  end

  def test_kindergarten_participation_rate_variation_against_another_district
    assert_equal 1.126, @ha.kindergarten_participation_rate_variation("GUNNISON WATERSHED RE1J", :against => "TELLURIDE R-1")
    assert_equal 0.446, @ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1')
  end

  def test_kindergarten_participation_rate_variation_trend
    actual = @ha.kindergarten_participation_rate_variation_trend('ACADEMY 20',:against => 'COLORADO')
    expected = {2004 => 1.258, 2005 => 0.96, 2006 => 1.05, 2007 => 0.992,
                2008 => 0.717, 2009 => 0.652, 2010 => 0.681, 2011 => 0.727,
                2012 => 0.687, 2013 => 0.693, 2014 => 0.661 }

    assert_equal expected, actual
  end

  def test_average_high_school_graduation_per_district
    average = @ha.average_high_school_graduation_per_district("ACADEMY 20")
    assert_equal 0.898, average
  end

  def test_high_school_graduation_rate_variation
    assert_equal 1.195, @ha.high_school_graduation_rate_variation('ACADEMY 20', :against => 'COLORADO')
  end

  def test_kindergarten_participation_against_high_school_graduation
    assert_equal 0.641, @ha.kindergarten_participation_against_high_school_graduation('ACADEMY 20')
    assert_equal 0.548, @ha.kindergarten_participation_against_high_school_graduation('MONTROSE COUNTY RE-1J')
    assert_equal 0.800, @ha.kindergarten_participation_against_high_school_graduation('STEAMBOAT SPRINGS RE-2')
  end

  def test_does_kindergarten_participation_predict_hs_graduation
    assert @ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'ACADEMY 20')
    refute @ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'MONTROSE COUNTY RE-1J')
    refute @ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'SIERRA GRANDE R-30')
    assert @ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'PARK (ESTES PARK) R-3')
  end

  def test_statewide_kindergarten_high_school_prediction
    refute @ha.kindergarten_participation_correlates_with_high_school_graduation(:for => 'STATEWIDE')
  end

  def test_kindergarten_hs_prediction_multi_district
    districts = ["ACADEMY 20", 'PARK (ESTES PARK) R-3', 'YUMA SCHOOL DISTRICT 1']
    assert @ha.kindergarten_participation_correlates_with_high_school_graduation(across: districts)
  end

  def test_correlation_across_all_districts
    refute @ha.correlation_across_all_districts
  end

  def test_correlation_across_some_districts
    districts = ["ACADEMY 20", 'PARK (ESTES PARK) R-3', 'YUMA SCHOOL DISTRICT 1']
    assert @ha.correlation_across_some_districts(across: districts)
  end
end
