require_relative 'test_helper'
require_relative '../lib/enrollment_repository'


class EnrollmentRepositoryTest < Minitest::Test

  def setup
    @er = EnrollmentRepository.new
    @enrollment_data = ({:enrollment =>{
                            :kindergarten => './data/Kindergartners in full-day program.csv',
                                :high_school_graduation => './data/High school graduation rates.csv'}
                          })
  end

  def test_it_initializes
    assert_instance_of EnrollmentRepository, @er
  end

  def test_data_can_be_loaded
    @er.load_data(@enrollment_data)

    assert_instance_of Array, @er.enrollments
  end

  def test_it_can_find_by_name
    @er.load_data(@enrollment_data)

    assert_instance_of Enrollment, @er.find_by_name('ACADEMY 20')
    assert_equal 'ACADEMY 20', @er.find_by_name('ACADEMY 20').name
  end

  def test_it_loads_enrollment
    @er.load_data(@enrollment_data)

    district = "ADAMS COUNTY 14"
    enrollment = @er.find_by_name(district)

    assert_equal district, enrollment.name

    assert_equal 0.227, enrollment.kindergarten_participation_in_year(2004)
  end

  def test_it_loads_high_school_data
    @er.load_data(@enrollment_data)

    district = "ADAMS-ARAPAHOE 28J"
    enrollment = @er.find_by_name(district)

    expected = {2010=>0.455, 2011=>0.485, 2012=>0.479, 2013=>0.526, 2014=>0.559}

    assert_equal district, enrollment.name
    assert_equal 0.971, enrollment.kindergarten_participation_in_year(2014)
    
    assert_equal expected, enrollment.graduation_rate_by_year
    assert_equal 0.455, enrollment.graduation_rate_in_year(2010)
  end
end
