class ConcussiveGrenade < Grenade

  def initialize
    @name = "ConcussiveGrenade"
    @weight = 1000
    @damage = 30
    @range = 1
  end

  def hit(target)
    target.wound(damage, true)
    splash = target.scan
    # byebug
    splash.each do |robot| 
      robot.wound(damage, true)
    end
  end

end