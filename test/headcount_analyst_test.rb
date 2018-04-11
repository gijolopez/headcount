require_relative 'test_helper'
require_relative '../lib/headcount_analyst'

class HeadcountAnalystTest < Minitest::Test

  def setup
    @dr = DistrictRepository.new
    data = ({:enrollment => {
                :kindergarten => './data/Kindergartners in full-day program.csv',
                    :high_school_graduation => './data/High school graduation rates.csv'}
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
end
