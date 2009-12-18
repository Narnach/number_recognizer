class NumberRecognizer
  KNOWN_FORMATS = {
    'Dutch mobile' => [316, 8],
    'Belgian mobile' => [324, 8],
    'Suriname' => [597,7],
    'Antilles' => [599,7]
  }
  attr_accessor :number

  def initialize(number)
    @number = number
  end

  def valid?
    if match = KNOWN_FORMATS.find {|name, pattern| number =~ /^0{0,2}#{pattern.first}\d{#{pattern.last},#{pattern.last}}$/}
      match
    else
      false
    end
  end
end