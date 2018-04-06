require_relative 'test_helper'
require_relative '../lib/headcount_analyst'

class HeadcountAnalystTest < Minitest::Test

  def test_it_exisit
    ha = HeadcountAnalyst.new

    assert_instance_of HeadcountAnalyst,ha
  end
end
