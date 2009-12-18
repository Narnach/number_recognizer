require File.join(File.dirname(__FILE__), %w[spec_helper])
require 'number_recognizer'

describe NumberRecognizer do
  describe 'correct' do
    it 'should recognize 0031612345678 as dutch mobile' do
      @nc = NumberRecognizer.new('0031612345678')
      @nc.should be_valid
      @nc.type.should == 'Dutch mobile'
    end

    it 'should recognize 0612345678 as dutch mobile' do
      @nc = NumberRecognizer.new('0612345678')
      @nc.should be_valid
      @nc.type.should == 'Dutch mobile'
    end

    it 'should recognize 0031201234567 as dutch landline' do
      @nc = NumberRecognizer.new('0031201234567')
      @nc.should be_valid
      @nc.type.should == 'Dutch landline'
    end

    it 'should recognize 0032412345678 as belgian mobile' do
      @nc = NumberRecognizer.new('0032412345678')
      @nc.should be_valid
      @nc.type.should == 'Belgian mobile'
    end

    it 'should recognize 005971234567 as a Suriname number' do
      @nc = NumberRecognizer.new('005971234567')
      @nc.should be_valid
      @nc.type.should == 'Suriname'
    end

    it 'should recognize 005991234567 as a Dutch Antilles number' do
      @nc = NumberRecognizer.new('005991234567')
      @nc.should be_valid
      @nc.type.should == 'Dutch Antilles'
    end

    it 'should be false when a nil number is provided' do
      @nc = NumberRecognizer.new(nil)
      @nc.should_not be_valid
      @nc.type.should be_nil
    end

    it 'should recognize 00441234567890 as an English number' do
      @nc = NumberRecognizer.new('00441234567890')
      @nc.should be_valid
      @nc.type.should == 'England'
    end
  end
end