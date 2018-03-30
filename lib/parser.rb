module Parser

  def parse_name(row)
    row[:name] = row[:location].upcase
  end
end
