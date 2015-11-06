require_relative 'spec_helper'

describe Robot do

  before :each do
    @robot = Robot.new
  end

  describe "#heal!" do

    it "should not heal when health is 0" do
      allow(@robot).to receive(:health).and_return(0)
      expect { @robot.heal!(10) }.to raise_error(Robot::DeadRobotError)
    end

  end

  describe "#attack!" do

    it "should only be able to attack robots and not items" do
      item = Item.new('rock', 5)
      expect { @robot.attack!(item) }.to raise_error(Robot::InvalidTargetError)
    end

  end

end