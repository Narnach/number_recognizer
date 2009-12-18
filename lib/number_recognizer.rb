class NumberRecognizer
  attr_accessor :type

  # Name -> [country code prefix match, digits after prefix]
  KNOWN_FORMATS = {
    'Dutch mobile' => [/(316|6)/, 8],
    'Dutch landline' => [/31[12345789]/, 8],
    'Belgian mobile' => [324, 8],
    'Suriname' => [597,7],
    'Dutch Antilles' => [599,7],
    'England' => [44,10]

  }
  attr_accessor :number

  def initialize(number)
    @number = number
  end

  def valid?
    self.type = nil
    return false unless match = KNOWN_FORMATS.find {|name, pattern| number =~ /^0{0,2}#{pattern.first}\d{#{pattern.last},#{pattern.last}}$/}
    self.type = match.first
    true
  end
end