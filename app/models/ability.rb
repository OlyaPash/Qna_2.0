# frozen_string_literal: true

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
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Subscription]
    can [:update, :destroy], [Question, Answer], user_id: user.id
    can :select_best, Answer, question: { user_id: user.id }
    can :destroy, Link, linkable: { user_id: user.id }
    can :destroy, Subscription, user_id: user.id

    can :comment, [Question, Answer] do |commentable|
      commentable.user_id != user.id
    end

    can [:like, :dislike, :cancel], [Question, Answer] do |votable|
      votable.user_id != user.id
    end
  end
end
