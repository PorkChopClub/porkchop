class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new(admin: false)

    if user.admin?
      can :manage, :all
    else
      can :read, :all
    end

    can :update, user
  end
end
