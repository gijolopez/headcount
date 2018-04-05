require_relative 'test_helper'
require_relative '../lib/enrollment_repository'


class EnrollmentRepositoryTest < Minitest::Test

  def setup
    @er = EnrollmentRepository.new
    @enrollment = {:enrollment =>
                   {:kindergarten =>
                     './fixtures/kindergarten_full_day.csv'
                   }}
  end
# './data/Kindergartners in full-day program.csv'
  def test_it_initializes
    assert_instance_of EnrollmentRepository, @er
  end

  def test_data_can_be_loaded
    @er.load_data(@enrollment)

    assert_instance_of Array, @er.enrollments
  end

  def test_it_can_find_by_name
    @er.load_data(@enrollment)

    assert_instance_of Enrollment, @er.find_by_name('ACADEMY 20')
    assert_equal 'ACADEMY 20', @er.find_by_name('ACADEMY 20').name
  end

end
