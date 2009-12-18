require File.join(File.dirname(__FILE__), %w[spec_helper])
require 'number_recognizer'

describe NumberRecognizer do
  describe 'correct' do
    it 'should recognize 0031612345678 as dutch mobile' do
      @nc = NumberRecognizer.new('0031612345678')
      @nc.should be_valid
    end

    it 'should recognize 0031201234567 as dutch landline' do
      @nc = NumberRecognizer.new('0031201234567')
      @nc.should be_valid
    end

    it 'should recognize 0032412345678 as belgian mobile' do
      @nc = NumberRecognizer.new('0032412345678')
      @nc.should be_valid
    end

    it 'should recognize 005971234567 as a Suriname number' do
      @nc = NumberRecognizer.new('005971234567')
      @nc.should be_valid
    end

    it 'should recognize 005991234567 as a Dutch Antilles number' do
      @nc = NumberRecognizer.new('005991234567')
      @nc.should be_valid
    end
  end
end