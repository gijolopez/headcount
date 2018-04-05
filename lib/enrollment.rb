require 'csv'

class Enrollment
  attr_reader :name
  attr_accessor :kindergarten_participation

  def initialize(data)
    @name = data[:name]
    @kindergarten_participation = data[:kindergarten_participation] || Hash.new
  end

  def kindergarten_participation_by_year
    @kindergarten_participation.reduce({}) do |value,key|
      key.merge(value.first => value.last)
      binding.pry
    end

  end

end
