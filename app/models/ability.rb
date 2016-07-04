class Ability
  include CanCan::Ability

  def initialize(player)
    player ||= Player.new

    if player.admin?
      can :manage, :all
    else
      can :read, :all
    end
  end
end
