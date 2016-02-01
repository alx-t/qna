class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
    can :search, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :manage, [Question, Answer], user: user
    can :create, Comment
    can :manage, Attachment, attachable: { user_id: user.id }

    alias_action :vote_up, :vote_down, :vote_reset, to: :vote
    can :vote, [Question, Answer]
    cannot :vote, [Question, Answer], user: user

    can :set_best, Answer, question: { user_id: user.id }

    can :subscribe, Question do |question|
      !question.subscribed? user
    end

    can :unsubscribe, Question do |question|
      question.subscribed? user
    end
  end
end

