class NumberRecognizer
  attr_accessor :type, :number, :old_number

  # Name -> pattern
  KNOWN_FORMATS = {
    'Dutch mobile' => /(316|6)\d{8,8}/,
    'Dutch landline' => /31[12345789]\d{8,8}/,
    'Belgian mobile' => /324\d{8,8}/,
    'Suriname' => /597\d{7,7}/,
    'Dutch Antilles' => /599\d{7,7}/,
    'England' => /44\d{9,10}/
  }

  def initialize(number)
    @number = number
  end

  def valid?
    self.type = nil
    return false unless match = KNOWN_FORMATS.find {|name, pattern| number =~ /^0{0,2}#{pattern}$/}
    self.type = match.first
    true
  end

  def correct
    old_number = number
    case number
    when /0[96]6*(\d{8})/
      self.number = "00316#{$1}"
    else
      return false
    end
    self.old_number = old_number
    true
  end
end