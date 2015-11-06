require_relative 'spec_helper'

describe Robot do

  before :each do
    @robot = Robot.new
  end

  describe '#initialize' do

    it "has starting shields of 50" do
        expect(@robot.shields).to be 50
    end

  end

  describe "#wound" do

    before :each do
      @robot2 = Robot.new
    end

    it "should lose shields before health" do
      @robot.attack!(@robot2)
      expect(@robot2.shields).to be 45
    end

    it "should lose reduced amount of health if amount exceeds shields" do
      allow(@robot2).to receive(:shields).and_return(5)
      @robot2.wound(20)
      expect(@robot2.health).to be 85
    end
  end

end