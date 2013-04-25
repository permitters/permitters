class Ability
  include CanCan::Ability

  def initialize(user)
    user.role.to_sym == :admin ? can(:manage, :all) : cannot(:manage, :all)
  end
end