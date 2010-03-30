class NumberRecognizer
  attr_accessor :number, :old_number, :type
  attr_accessor :country, :local_number

  # Name -> pattern
  KNOWN_FORMATS = {
    'Dutch mobile' => /(31)(6\d{8,8})/,
    'Dutch landline' => /(31)([12345789]\d{8,8})/,
    'Belgian mobile' => /(32)(4\d{8,8})/,
    'Suriname' => /(597)(\d{7,7})/,
    'Dutch Antilles' => /(599)(\d{7,7})/,
    'England' => /(44)(\d{9,10})/,
    'Australia mobile' => /(61)(4\d{8})/,
    'Austraia' => /(61)([1-35-9]\d{8})/,
  }

  def initialize(number)
    @number = number
  end

  def mobile?
    self.valid? if self.type.nil?
    self.type.to_s =~ /mobile/
  end

  def valid_or_correct_mobile?
    return false unless valid? or correct
    mobile?
  end

  # Set type, country and local_number
  def valid?
    number = self.number.to_s
    self.type, pattern = KNOWN_FORMATS.find {|name, pattern| number.match /^0{0,2}#{pattern}$/}
    return false unless pattern
    match = number.match(pattern)
    self.country = match[1]
    self.local_number = match[2]
    true
  end

  def correct
    old_number = number
    case number
    when /^0[96]6*(\d{8})$/
      self.number = "316#{$1}"
    when /^04(\d{8})$/
      self.number = "324#{$1}"
    else
      return false
    end
    self.old_number = old_number
    valid?
  end

  def normalized_number
    "#{country}#{local_number}"
  end
end