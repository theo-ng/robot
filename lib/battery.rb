class Battery < Item

  def initialize
    super("Battery", 25)
  end

  def recharge(robot)
    robot.restore_shields
  end

end