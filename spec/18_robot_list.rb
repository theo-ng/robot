require_relative 'spec_helper'

describe Robot do

  before :each do
    Robot.class_variable_set :@@robots, []
    @robot1 = Robot.new
    @robot2 = Robot.new
    @robot3 = Robot.new
    @robot4 = Robot.new
    allow(@robot3).to receive(:position).and_return([1,2])
    allow(@robot4).to receive(:position).and_return([1,0])
  end

  describe '#robots' do

    it "should return a list of all robots" do
      expect(Robot.robots).to eq([@robot1, @robot2, @robot3, @robot4])
    end

  end

  describe '.in_position' do

    it "should return a list of all robots at (x,y)" do
      expect(Robot.in_position(0,0)).to eq([@robot1, @robot2])
    end

  end

  describe '#scan' do

    it 'should return a list of robots immediately next to it' do
      expect(@robot1.scan).to eq([@robot2, @robot4])
    end

  end

end