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
end
