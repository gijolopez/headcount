require 'csv'

class Enrollment
  attr_reader :name
  attr_accessor :kindergarten_participation

  def initialize(data)
    @name = data[:name]
    @kindergarten_participation = data[:kindergarten_participation] || Hash.new
  end

end
