require 'csv'

class Enrollment
  attr_reader :name

  def initialize(data)
    @name = data[:name]
  end

end
