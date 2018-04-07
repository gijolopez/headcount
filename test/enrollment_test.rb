require_relative 'test_helper'
require_relative '../lib/enrollment'

class EnrollmentTest < Minitest::Test

  def setup
    @e = Enrollment.new({:name => "ACADEMY 20",
                          :kindergarten_participation =>
                                    {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

  end

  def test_it_exists
    assert_instance_of Enrollment, @e
  end

  def test_it_has_attributes
    assert_equal "ACADEMY 20", @e.name
    assert_instance_of Hash, @e.kindergarten_participation
  end

  def test_kindergarten_participation_by_year
    expected = {2010 => 0.391, 2011 => 0.353, 2012 => 0.267}
    actual = @e.kindergarten_participation_by_year

    assert_equal expected, actual
  end

  def test_it_convert_decimals_to_three_points
    actual = @e.convert_to_three_decimals(0.2677)
    expected = 0.267

    assert_equal expected, actual
  end

  def test_kindergarten_participation_in_year
    assert_equal 0.391, @e.kindergarten_participation_in_year(2010)
  end

  def test_graduation_rate_by_year

  end

  def test_enrollment_repository_with_high_school_data
    er = EnrollmentRepository.new
    er.load_data({ :enrollment => {
                        :kindergarten => "./data/Kindergartners in full-day program.csv",
                              :high_school_graduation => "./data/High school graduation rates.csv"
                   }})
    e = er.find_by_name("MONTROSE COUNTY RE-1J")

    expected = {2010=>0.738, 2011=>0.751, 2012=>0.777, 2013=>0.713, 2014=>0.757}
    actual = e.graduation_rate_by_year

    assert_equal expected, actual
    end
  #   assert_in_delta 0.738, e.graduation_rate_in_year(2010), 0.005
  # end
end
