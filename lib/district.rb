class District
  attr_reader :name

  def initialize(data)
    @name       = data[:name]
    @enrollment = nil
  end
end
