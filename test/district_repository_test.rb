require_relative 'test_helper'
require_relative '../lib/district_repository'


class DistrictRepositoryTest < Minitest::Test

  def setup
    @dr = DistrictRepository.new
    @kinder_data = ({ :enrollment =>
                        { :kindergarten =>
                            './data/Kindergartners in full-day program.csv',
                                  :high_school_graduation => "./data/High school graduation rates.csv"}
                    })
  end

  def test_it_initializes
    assert_instance_of DistrictRepository, @dr
  end

  def test_data_can_be_loaded
    @dr.load_data(@kinder_data)

    assert_instance_of Array, @dr.districts
  end

  def test_it_can_find_by_name
    @dr.load_data(@kinder_data)

    assert_instance_of District, @dr.find_by_name('ACADEMY 20')
    assert_equal 'ACADEMY 20', @dr.find_by_name('ACADEMY 20').name
  end

  def test_it_can_find_all_matching
    @dr.load_data(@kinder_data)

    assert_instance_of Array, @dr.find_all_matching('ACADEMY 20')
    assert_equal 1, @dr.find_all_matching('ACADEMY 20').count
    assert_equal 7, @dr.find_all_matching('WE').count
  end

  def test_it_instantiates_enrollment
    @dr.load_data(@kinder_data)
    district = @dr.find_by_name("ACADEMY 20")

    assert_instance_of Enrollment, district.enrollment
  end

  def test_it_can_create_enrollment_from_district
    @dr.load_data(@kinder_data)
    district = @dr.find_by_name("GUNNISON WATERSHED RE1J")

    assert_equal 0.144, district.enrollment.kindergarten_participation_in_year(2004)
  end

  def test_it_instantiates_statewide
    @dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv",
          },
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
        }})

    district = @dr.find_by_name("ACADEMY 20")
    statewide_test = district.statewide_test

    assert_instance_of StatewideTest, statewide_test
  end
end
