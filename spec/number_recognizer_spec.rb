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
      @nc.type.should be_nil
    end

    it 'should recognize 0031612345678 as dutch mobile' do
      @nc = NumberRecognizer.new('0031612345678')
      @nc.should be_valid
      @nc.country.should == '31'
      @nc.local_number.should == '612345678'
      @nc.type.should == 'Dutch mobile'
    end

    it 'should recognize 0031201234567 as dutch landline' do
      @nc = NumberRecognizer.new('0031201234567')
      @nc.should be_valid
      @nc.country.should == '31'
      @nc.local_number.should == '201234567'
      @nc.type.should == 'Dutch landline'
    end

    it 'should recognize 0032412345678 as belgian mobile' do
      @nc = NumberRecognizer.new('0032412345678')
      @nc.should be_valid
      @nc.country.should == '32'
      @nc.local_number.should == '412345678'
      @nc.type.should == 'Belgian mobile'
    end

    it 'should recognize 005971234567 as a Suriname number' do
      @nc = NumberRecognizer.new('005971234567')
      @nc.should be_valid
      @nc.country.should == '597'
      @nc.local_number.should == '1234567'
      @nc.type.should == 'Suriname'
    end

    it 'should recognize 005991234567 as a Dutch Antilles number' do
      @nc = NumberRecognizer.new('005991234567')
      @nc.should be_valid
      @nc.country.should == '599'
      @nc.local_number.should == '1234567'
      @nc.type.should == 'Dutch Antilles'
    end

    it 'should recognize 00441234567890 as an English number' do
      @nc = NumberRecognizer.new('00441234567890')
      @nc.should be_valid
      @nc.country.should == '44'
      @nc.local_number.should == '1234567890'
      @nc.type.should == 'England'
    end

    it 'should recognize 0044123456789 as an English number' do
      @nc = NumberRecognizer.new('0044123456789')
      @nc.should be_valid
      @nc.country.should == '44'
      @nc.local_number.should == '123456789'
      @nc.type.should == 'England'
    end

    it 'should recognize 0044712345678 as an English mobile number' do
      @nc = NumberRecognizer.new('0044712345678')
      @nc.should be_valid
      @nc.should be_valid_or_correct_mobile
      @nc.country.should == '44'
      @nc.local_number.should == '712345678'
      @nc.type.should == 'England mobile'
    end

    it 'should recognize 0061451124205 as an Australian number' do
      @nc = NumberRecognizer.new('0061451124205')
      @nc.should be_valid
      @nc.country.should == '61'
      @nc.local_number.should == '451124205'
      @nc.type.should == 'Australia mobile'
    end
  end

  describe "correct" do
    it 'should correct 06612345678 to 0031612345678' do
      @nc = NumberRecognizer.new('06612345678')
      @nc.should_not be_valid

      @nc.correct.should be_true
      @nc.number.should == '31612345678'
      @nc.old_number.should == '06612345678'

      @nc.type.should == 'Dutch mobile'
      @nc.country.should == '31'
      @nc.local_number.should == '612345678'
    end

    it 'should correct 09612345678 to 0031612345678' do
      @nc = NumberRecognizer.new('09612345678')
      @nc.should_not be_valid

      @nc.correct.should be_true
      @nc.number.should == '31612345678'
      @nc.old_number.should == '09612345678'

      @nc.type.should == 'Dutch mobile'
      @nc.country.should == '31'
      @nc.local_number.should == '612345678'
    end

    it 'should correct 0612345678 to 0031612345678' do
      @nc = NumberRecognizer.new('0612345678')
      @nc.should_not be_valid

      @nc.correct.should be_true
      @nc.number.should == '31612345678'
      @nc.old_number.should == '0612345678'

      @nc.type.should == 'Dutch mobile'
      @nc.country.should == '31'
      @nc.local_number.should == '612345678'
    end

    it 'should correct 07123456789 to 00447123456789' do
      @nc = NumberRecognizer.new('07123456789')
      @nc.should_not be_valid

      @nc.correct.should be_true
      @nc.number.should == '447123456789'
      @nc.old_number.should == '07123456789'

      @nc.type.should == 'England mobile'
      @nc.country.should == '44'
      @nc.local_number.should == '7123456789'
    end

    it 'should correct 7123456789 to 00447123456789' do
      @nc = NumberRecognizer.new('7123456789')
      @nc.should_not be_valid

      @nc.correct.should be_true
      @nc.number.should == '447123456789'
      @nc.old_number.should == '7123456789'

      @nc.type.should == 'England mobile'
      @nc.country.should == '44'
      @nc.local_number.should == '7123456789'
    end

    it 'should correct 0412345678 to 32412345678' do
      @nc = NumberRecognizer.new('0412345678')
      @nc.should_not be_valid

      @nc.correct.should be_true
      @nc.number.should == '32412345678'
      @nc.old_number.should == '0412345678'

      @nc.type.should == 'Belgian mobile'
      @nc.country.should == '32'
      @nc.local_number.should == '412345678'
    end

    it 'should correct 0412345678 to 61412345678 given a country-bias for 61' do
      @nc = NumberRecognizer.new('0412345678')
      @nc.should_not be_valid

      @nc.correct(61).should be_true
      @nc.number.should == '61412345678'
      @nc.old_number.should == '0412345678'

      @nc.type.should == 'Australia mobile'
      @nc.country.should == '61'
      @nc.local_number.should == '412345678'
    end
  end

  describe 'valid or correct mobile' do
    it 'should correct 0612345678 to 0031612345678' do
      @nc = NumberRecognizer.new('0612345678')
      @nc.should be_valid_or_correct_mobile

      @nc.type.should == 'Dutch mobile'
      @nc.country.should == '31'
      @nc.local_number.should == '612345678'
    end

    it 'should correct 612345678 to 0031612345678' do
      @nc = NumberRecognizer.new('612345678')
      @nc.should be_valid_or_correct_mobile

      @nc.type.should == 'Dutch mobile'
      @nc.country.should == '31'
      @nc.local_number.should == '612345678'
    end

    it 'should accept 0032412345678' do
      @nc = NumberRecognizer.new('0032412345678')
      @nc.should be_valid_or_correct_mobile

      @nc.type.should == 'Belgian mobile'
      @nc.country.should == '32'
      @nc.local_number.should == '412345678'
    end

    it 'should accept 0412345678 as Australia Mobile given a country-bias for 61' do
      @nc = NumberRecognizer.new('0412345678')
      @nc.valid_or_correct_mobile?(61).should be_true

      @nc.type.should == 'Australia mobile'
      @nc.country.should == '61'
      @nc.local_number.should == '412345678'
    end

    it 'should accept 412345678 as Australia Mobile given a country-bias for 61' do
      @nc = NumberRecognizer.new('412345678')
      @nc.valid_or_correct_mobile?(61).should be_true

      @nc.type.should == 'Australia mobile'
      @nc.country.should == '61'
      @nc.local_number.should == '412345678'
    end

    it 'should correct 0913773785 to 00351913773785' do
      @nc = NumberRecognizer.new('0913773785')
      @nc.should be_valid_or_correct_mobile

      @nc.type.should == 'Portugal mobile'
      @nc.country.should == '351'
      @nc.local_number.should == '913773785'
    end

    it 'should correct 913773785 to 00351913773785' do
      @nc = NumberRecognizer.new('913773785')
      @nc.should be_valid_or_correct_mobile

      @nc.type.should == 'Portugal mobile'
      @nc.country.should == '351'
      @nc.local_number.should == '913773785'
    end

  end

  describe 'mobile?' do
    it 'should recognize 31612345678 as a mobile number' do
      @nc = NumberRecognizer.new('0031612345678')
      @nc.should be_mobile
    end

    it 'should recognize 31202345678 as not mobile number' do
      @nc = NumberRecognizer.new('31202345678')
      @nc.should_not be_mobile
    end
  end
end