require 'matrix'

class Robot

  class DeadRobotError < StandardError
  end

  class InvalidTargetError < StandardError
  end

  attr_reader :position, :items, :health, :range, :equipped_weapon

  WEIGHT_CAPACITY = 250
  MAX_HEALTH = 100
  DEFAULT_DAMAGE = 5

  def initialize
    @position = [0,0]
    @items = []
    @health = MAX_HEALTH
    @equipped_weapon = nil
    @range = 1
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
    if can_pick_up?(item)
      self.equipped_weapon = item if item.is_a? Weapon
      item.feed(self) if item.is_a?(BoxOfBolts) && should_eat?
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
  def wound(amount)
    damage = health - amount
    @health = damage >= 0 ? damage : 0
  end

  def heal(amount)
    restored = health + amount
    @health = restored > MAX_HEALTH ? MAX_HEALTH : restored
  end

  def attack(target)
    if can_attack?(target) && has_weapon?
      equipped_weapon.hit(target)
      dispense_weapon(equipped_weapon) if equipped_weapon.is_a? Grenade
    elsif can_attack?(target)
      target.wound(DEFAULT_DAMAGE)
    end
  end

  def has_weapon?
    equipped_weapon.is_a? Weapon
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
  end

  private :can_attack?, :has_weapon?, :can_pick_up?, :dispense_weapon

end