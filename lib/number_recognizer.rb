class NumberRecognizer
  attr_accessor :number

  def initialize(number)
    @number = number
  end

  def valid?
    valid_dutch_mobile? or valid_belgian_mobile? or valid_suriname? or valid_antilles?
  end

  def valid_dutch_mobile?
    number =~ /^00316\d{8,8}$/
  end

  def valid_belgian_mobile?
    number =~ /^00324\d{8,8}$/
  end

  def valid_suriname?
    number =~ /^00597\d{7,7}/
  end

  def valid_antilles?
    number =~ /^00599\d{7,7}/
  end
end