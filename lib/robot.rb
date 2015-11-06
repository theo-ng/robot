require 'matrix'

class Robot

  class DeadRobotError < StandardError
  end

  class InvalidTargetError < StandardError
  end

  attr_reader :position, :items, :health, :range, :equipped_weapon, :shields

  WEIGHT_CAPACITY = 250
  MAX_HEALTH = 100
  DEFAULT_DAMAGE = 5
  MAX_SHIELDS = 50
  DEFAULT_RANGE = 1

  @@robots = []

  def initialize
    @position = [0,0]
    @items = []
    @health = MAX_HEALTH
    @shields = MAX_SHIELDS
    @equipped_weapon = nil
    @range = DEFAULT_RANGE
    @@robots << self
  end


  # 2d moving
  def move_left
    @position[0] -= 1
  end

  def move_right
    @position[0] += 1
  end

  def move_up
    @position[1] += 1
  end

  def move_down
    @position[1] -= 1
  end

  # stuff with items
  def pick_up(item)
    item.feed(self) if item.is_a?(BoxOfBolts) && should_eat?
    if can_pick_up?(item)
      self.equipped_weapon = item if item.is_a? Weapon
      @items << item
    end
  end

  def can_pick_up?(item)
    items_weight + item.weight <= WEIGHT_CAPACITY
  end

  def items_weight
    @items.reduce(0) { |weight, item| weight += item.weight}
  end

  # health stuff
  def wound(amount, piercing = false)
    block(amount) unless piercing
    @health = amount > health ? 0 : health - amount if piercing
  end

  def block(amount)
    if amount > shields
      amount -= shields
      @shields = 0
      # byebug
      wound(amount, true)
    else
      @shields -= amount
    end
  end

  def heal(amount)
    restored = health + amount
    @health = restored > MAX_HEALTH ? MAX_HEALTH : restored
  end

  def attack(target)
    if can_attack?(target) && equipped_weapon
      equipped_weapon.hit(target)
      dispense_weapon(equipped_weapon) if equipped_weapon.is_a? Grenade
    elsif can_attack?(target)
      target.wound(DEFAULT_DAMAGE)
    end
  end

  # enhancements 1

  def heal!(amount)
    raise DeadRobotError, "Cannot heal dead robot" if health <= 0
    heal(amount)
  end

  def attack!(target)
    raise InvalidTargetError, "That's not a robot!" unless target.is_a? Robot
    attack(target)
  end

  # enhancements 2

  def can_attack?(target)
    distance = Vector.elements(target.position) - Vector.elements(position)
    distance[0].abs <= range && distance[1].abs <= range
  end

  def should_eat?
    health <= 80
  end

  def equipped_weapon=(weapon)
    @equipped_weapon = weapon
    @range = weapon.range
  end

  def dispense_weapon(weapon)
    @equipped_weapon = nil
    @items.delete(weapon)
    @range = DEFAULT_RANGE
  end

  def restore_shields
    @shields = MAX_SHIELDS
  end

  def scan
    @@robots.select do |robot|
      x_distance = (robot.position[0] - position[0]).abs
      y_distance = (robot.position[1] - position[1]).abs
      robot != self && x_distance <= 1 && y_distance <= 1
    end
  end

  class << self
    def robots
      @@robots
    end

    def in_position(x, y)
      @@robots.select { |robot| robot.position == [x,y] }
    end

  end

  private :can_attack?, :can_pick_up?, :dispense_weapon

end