class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Recipe, public: true
    can :manage, Recipe, user:
  end
end
