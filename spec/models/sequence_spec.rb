require 'spec_helper'

describe Sequence do
  it 'should find the next arithmetic sequence' do
    Sequence.find_sequence([1,2,3,4,5,6]).should == 7
    Sequence.find_sequence([1,3,5,7]).should == 9
    Sequence.find_sequence([8,11.5,15,18.5]).should == 22.0
  end

  it 'should find the next geometric sequence' do
    Sequence.find_sequence([2,4,8,16]).should == 32.0
    Sequence.find_sequence([2.25,2.8125,3.515625,4.39453125]).should == 5.4931640625
  end

  it 'should return nil for error in a sequence' do
    Sequence.find_sequence([2.25,2.8125,3.515625,1]).should be_nil
  end

  it 'should handle 0 case' do
    Sequence.find_sequence([0,1,2,3]).should == 4
    Sequence.find_sequence([0,0,0,0]).should == 0
  end
end