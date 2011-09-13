require 'number_recognizer/format_dsl'

class NumberRecognizer
  include FormatDsl

  # Input
  attr_accessor :number, :old_number, :country_name, :country, :local_number, :prefix

  add_format :country => "Netherlands", :mobile=>true, :format => /(31)(6\d{8})/
  add_format :country => "Belgium",     :mobile=>true, :format => /(32)(4\d{8})/
  add_format :country => "England",     :mobile=>true, :format => /(44)(7\d{8,9})/            # http://en.wikipedia.org/wiki/Telephone_numbers_in_England
  add_format :country => "Australia",   :mobile=>true, :format => /(61)(4\d{8})/              # http://en.wikipedia.org/wiki/Telephone_numbers_in_Australia
  add_format :country => "Portugal",    :mobile=>true, :format => /(351)(9\d{8})/
  add_format :country => "Spain",       :mobile=>true, :format => /(34)((6\d|7[1-9])\d{7})/   # http://en.wikipedia.org/wiki/Telephone_numbers_in_Spain

  add_format :country => "Netherlands",     :mobile=>false, :format => /(31)([123457890]\d{8})/
  add_format :country => "Suriname",        :mobile=>false, :format => /(597)(\d{7,7})/
  add_format :country => "Dutch Antilles",  :mobile=>false, :format => /(599)(\d{7,7})/
  add_format :country => "England",         :mobile=>false, :format => /(44)([0-68-9]\d{8,9})/
  add_format :country => "Australia",       :mobile=>false, :format => /(61)([1-35-9]\d{8})/

  def initialize(number)
    @number = number
    @parsed = false
    @corrected = false

    @valid = nil
    @mobile = nil
  end

  def mobile?
    parse unless @parsed
    @mobile
  end

  def valid?
    parse unless @parsed
    @valid
  end

  def valid_or_correct_mobile?(country_bias=nil)
    correct(country_bias)
    valid? && mobile?
  end

  def normalized_number
    parse unless @parsed
    "#{prefix}#{local_number}"
  end

  def correct(country_bias=nil)
    @corrected = false
    old_number = number
    case number
    when /^0?9([136]\d{7})$/ #this must come before NL !
      self.number = "3519#{$1}"
    when /^0?7([1-9]\d{7})$/ # 07 can't be followed by a 0 in spain. It's legal in England.
      prefix = pick_biased_country([44,34], country_bias)
      self.number = "#{prefix}7#{$1}"
    when /^0?7(0\d{7})$/ # 07 can't be followed by a 0 in spain. It's legal in England.
      prefix = pick_biased_country([44], country_bias)
      self.number = "#{prefix}7#{$1}"
    when /^0?7(\d{9})$/ # Spanish numbers have 8 digits after the 07. English numbers can also have 9 digits after the 07.
      prefix = pick_biased_country([44], country_bias)
      self.number = "#{prefix}7#{$1}"
    when /^0?6+(\d{8})$/
      prefix = pick_biased_country([31,34], country_bias)
      self.number = "#{prefix}6#{$1}"
    when /^0?4(\d{8})$/
      prefix = pick_biased_country([32,61], country_bias)
      self.number = "#{prefix}4#{$1}"
    else
      # No correction, so no need re-parse
      @corrected = true
      return valid?
    end
    self.old_number = old_number
    @parsed = false
    @corrected = true
    valid?
  end

  def type
    return nil unless valid?
    "#{country_name} #{mobile? ? "mobile" : "landline"}"
  end

  def country=(country)
    @country = country.to_s
  end

  def prefix=(prefix)
    @prefix = prefix.to_s
  end

  private

  def parse
    @parsed = true
    @valid = false
    number = self.number.to_s.sub(/^0+/,'')
    format = self.class.formats.find {|format| number.match(format[:format])}
    unless format
      return
    end
    @mobile = format[:mobile]
    self.country_name = format[:country]

    match = number.match(format[:format])
    self.prefix = match[1]
    self.country = format[:country_code] || self.prefix
    self.local_number = match[2]
    @valid = true
    nil
  end

  def pick_biased_country(allowed_countries, bias=nil)
    country_bias = [bias].flatten.compact
    whitelisted_bias = country_bias & allowed_countries
    return whitelisted_bias.first || allowed_countries.first
  end
end
