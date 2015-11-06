require_relative 'spec_helper'

describe Battery do

  before :each do
    @battery = Battery.new
  end

  describe "#new" do

    it "should be an item" do
      expect(@battery).to be_a Battery
    end

    it "should have a weight of 25" do
      expect(@battery.weight).to be 25
    end

    it "should have name of 'Battery'" do
      expect(@battery.name).to eq "Battery"
    end

  end

  describe "#recharge" do

    it "should recharge shields of robot" do
      robot = Robot.new
      robot.wound(30)
      @battery.recharge(robot)
      expect(robot.shields).to be 50
    end

  end

end