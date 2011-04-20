require File.join(File.dirname(__FILE__), %w[spec_helper])
require 'number_recognizer'

describe NumberRecognizer do
  it 'should normalize numbers' do
    @nc = NumberRecognizer.new('0031612345678')
    @nc.valid?
    @nc.country.should == '31'
    @nc.local_number.should == '612345678'
    @nc.normalized_number.should == '31612345678'
  end

  describe 'valid?' do
    it 'should be false when a nil number is provided' do
      @nc = NumberRecognizer.new(nil)
      @nc.should_not be_valid
      @nc.country_name.should be_nil
    end

    it 'should recognize 0031612345678' do
      @nc = NumberRecognizer.new('0031612345678')
      @nc.should be_valid
      @nc.country.should == '31'
      @nc.local_number.should == '612345678'
      @nc.country_name.should == 'Netherlands'
    end

    it 'should recognize 0031201234567' do
      @nc = NumberRecognizer.new('0031201234567')
      @nc.should be_valid
      @nc.country.should == '31'
      @nc.local_number.should == '201234567'
      @nc.country_name.should == 'Netherlands'
    end

    it 'should recognize 0032412345678' do
      @nc = NumberRecognizer.new('0032412345678')
      @nc.should be_valid
      @nc.country.should == '32'
      @nc.local_number.should == '412345678'
      @nc.country_name.should == 'Belgium'
    end

    it 'should recognize 005971234567' do
      @nc = NumberRecognizer.new('005971234567')
      @nc.should be_valid
      @nc.country.should == '597'
      @nc.local_number.should == '1234567'
      @nc.country_name.should == 'Suriname'
    end

    it 'should recognize 005991234567' do
      @nc = NumberRecognizer.new('005991234567')
      @nc.should be_valid
      @nc.country.should == '599'
      @nc.local_number.should == '1234567'
      @nc.country_name.should == 'Dutch Antilles'
    end

    it 'should recognize 00441234567890' do
      @nc = NumberRecognizer.new('00441234567890')
      @nc.should be_valid
      @nc.country.should == '44'
      @nc.local_number.should == '1234567890'
      @nc.country_name.should == 'England'
    end

    it 'should recognize 0044123456789' do
      @nc = NumberRecognizer.new('0044123456789')
      @nc.should be_valid
      @nc.country.should == '44'
      @nc.local_number.should == '123456789'
      @nc.country_name.should == 'England'
    end

    it 'should recognize 0044712345678' do
      @nc = NumberRecognizer.new('0044712345678')
      @nc.should be_valid
      @nc.should be_valid_or_correct_mobile
      @nc.country.should == '44'
      @nc.local_number.should == '712345678'
      @nc.country_name.should == 'England'
    end

    it 'should recognize 0061451124205' do
      @nc = NumberRecognizer.new('0061451124205')
      @nc.should be_valid
      @nc.country.should == '61'
      @nc.local_number.should == '451124205'
      @nc.country_name.should == 'Australia'
    end

    it 'should recognize 00351927123456' do
      @nc = NumberRecognizer.new('00351927123456')
      @nc.should be_valid
      @nc.country.should == '351'
      @nc.local_number.should == '927123456'
      @nc.country_name.should == 'Portugal'
    end
  end

  describe "correct" do
    it 'should correct 06612345678 to 0031612345678' do
      @nc = NumberRecognizer.new('06612345678')
      @nc.should_not be_valid

      @nc.correct.should be_true
      @nc.number.should == '31612345678'
      @nc.old_number.should == '06612345678'
    end

    it 'should correct 0612345678 to 0031612345678' do
      @nc = NumberRecognizer.new('0612345678')
      @nc.should_not be_valid

      @nc.correct.should be_true
      @nc.number.should == '31612345678'
      @nc.old_number.should == '0612345678'
    end

    it 'should correct 07123456789 to 00447123456789' do
      @nc = NumberRecognizer.new('07123456789')
      @nc.should_not be_valid

      @nc.correct.should be_true
      @nc.number.should == '447123456789'
      @nc.old_number.should == '07123456789'
    end

    it 'should correct 7123456789 to 00447123456789' do
      @nc = NumberRecognizer.new('7123456789')
      @nc.should_not be_valid

      @nc.correct.should be_true
      @nc.number.should == '447123456789'
      @nc.old_number.should == '7123456789'
    end

    it 'should correct 0412345678 to 32412345678' do
      @nc = NumberRecognizer.new('0412345678')
      @nc.should_not be_valid

      @nc.correct.should be_true
      @nc.number.should == '32412345678'
      @nc.old_number.should == '0412345678'
    end

    it 'should correct 0412345678 to 61412345678 given a country-bias for 61' do
      @nc = NumberRecognizer.new('0412345678')
      @nc.should_not be_valid

      @nc.correct(61).should be_true
      @nc.number.should == '61412345678'
      @nc.old_number.should == '0412345678'
    end
  end

  describe 'valid or correct mobile' do
    it 'should correct 0612345678 to 0031612345678' do
      @nc = NumberRecognizer.new('0612345678')
      @nc.should be_valid_or_correct_mobile

      @nc.country_name.should == 'Netherlands'
      @nc.country.should == '31'
      @nc.local_number.should == '612345678'
    end

    it 'should correct 612345678 to 0031612345678' do
      @nc = NumberRecognizer.new('612345678')
      @nc.should be_valid_or_correct_mobile

      @nc.country_name.should == 'Netherlands'
      @nc.country.should == '31'
      @nc.local_number.should == '612345678'
    end

    it 'should accept 0032412345678' do
      @nc = NumberRecognizer.new('0032412345678')
      @nc.should be_valid_or_correct_mobile

      @nc.country_name.should == 'Belgium'
      @nc.country.should == '32'
      @nc.local_number.should == '412345678'
    end

    it 'should accept 0412345678 as Australia given a country-bias for 61' do
      @nc = NumberRecognizer.new('0412345678')
      @nc.valid_or_correct_mobile?(61).should be_true

      @nc.country_name.should == 'Australia'
      @nc.country.should == '61'
      @nc.local_number.should == '412345678'
    end

    it 'should accept 412345678 as Australia given a country-bias for 61' do
      @nc = NumberRecognizer.new('412345678')
      @nc.valid_or_correct_mobile?(61).should be_true

      @nc.country_name.should == 'Australia'
      @nc.country.should == '61'
      @nc.local_number.should == '412345678'
    end

    it 'should correct 0913773785 to 00351913773785' do
      @nc = NumberRecognizer.new('0913773785')
      @nc.should be_valid_or_correct_mobile

      @nc.country_name.should == 'Portugal'
      @nc.country.should == '351'
      @nc.local_number.should == '913773785'
    end

    it 'should correct 913773785 to 00351913773785' do
      @nc = NumberRecognizer.new('913773785')
      @nc.should be_valid_or_correct_mobile

      @nc.country_name.should == 'Portugal'
      @nc.country.should == '351'
      @nc.local_number.should == '913773785'
    end

    it "should return false for a landline number" do
      @nc = NumberRecognizer.new('31201234567')
      @nc.should_not be_valid_or_correct_mobile
    end

    it "should return false for a corrupted mobile number" do
      @nc = NumberRecognizer.new('061234567')
      @nc.should_not be_valid_or_correct_mobile
    end
  end

  describe 'mobile?' do
    it 'should recognize 31612345678 as a mobile number' do
      @nc = NumberRecognizer.new('0031612345678')
      @nc.should be_mobile
    end

    it 'should recognize 31201234567 as not mobile number' do
      @nc = NumberRecognizer.new('31201234567')
      @nc.should_not be_mobile
    end
  end

  describe "type" do
    it "should compose country and mobile/landline status" do
      @nc = NumberRecognizer.new('31612345678')
      @nc.type.should == "Netherlands mobile"
      @nc = NumberRecognizer.new('31201234567')
      @nc.type.should == "Netherlands landline"
    end
  end
end
