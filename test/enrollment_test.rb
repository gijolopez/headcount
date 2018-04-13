require_relative 'test_helper'
require_relative '../lib/enrollment'
require_relative '../lib/enrollment_repository'


class EnrollmentTest < Minitest::Test

  def setup
    @e = Enrollment.new({
      :name => "ACADEMY 20",
          :kindergarten_participation =>
              {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    @er = EnrollmentRepository.new
    @high_school_data = ({ :enrollment => {
        			                :kindergarten => './data/Kindergartners in full-day program.csv',
        				               :high_school_graduation => './data/High school graduation rates.csv'}
                                  })
  end

  def test_it_exists
    assert_instance_of Enrollment, @e
  end

  def test_it_has_attributes
    assert_equal "ACADEMY 20", @e.name
    assert_instance_of Hash, @e.kindergarten_participation
    assert_instance_of Hash, @e.high_school_graduation_rates
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
    @er.load_data(@high_school_data)
    enrollment = @er.find_by_name("ACADEMY 20")

    expected = {2010 => 0.895, 2011 => 0.895, 2012 => 0.889, 2013 => 0.913, 2014 => 0.898}
    actual = enrollment.graduation_rate_by_year

    assert_equal expected, actual
  end

  def test_graduation_rate_in_year
    @er.load_data(@high_school_data)
    enrollment = @er.find_by_name("ACADEMY 20")

    assert_equal 0.898, enrollment.graduation_rate_in_year(2014)
  end

end
