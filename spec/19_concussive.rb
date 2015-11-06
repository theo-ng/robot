require_relative 'spec_helper'

describe ConcussiveGrenade do

  before :each do
    @concussive = ConcussiveGrenade.new
    @robot = Robot.new
    @robot2 = Robot.new
    @robot3 = Robot.new
    @robot4 = Robot.new
    allow(@robot3).to receive(:position).and_return [1,0]
    allow(@robot4).to receive(:position).and_return [2,2]
  end

  describe "#init" do

    it "should make a new ConcussiveGrenade" do
      expect(@concussive).to be_a ConcussiveGrenade
    end

    it "should weigh 1000" do
      expect(@concussive.weight).to be 1000
    end

  end

  describe "#hit" do

    before :each do
      allow(@robot).to receive(:equipped_weapon).and_return(@concussive)
      @robot.attack!(@robot2)
    end

    it "should do piercing damage to all target" do
      expect(@robot2.health).to be 70
    end

    it "should do damage to robots in splash range" do
      expect(@robot3.health).to be 70
    end

    it "should not do damage to robots outside of splash range" do
      expect(@robot4.health).to be 100
    end
  end

end