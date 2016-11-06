class Ability
  include CanCan::Ability

  def initialize(player)
    player ||= Player.new

    can :update, Player, id: player.id

    if player.admin?
      can :manage, :all
    else
      can :read, :all
    end
  end
end
