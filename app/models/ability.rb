class Ability
  include CanCan::Ability

  def initialize(user)
    if user.has_role?(:admin)
      # admin
      can :manage, :all
    elsif user.has_role?(:member)
      # Record
      can :create, Record
      can :read, Record do |record|
        record.deleted == false and
        user.group_members(true).map(&:id).include?(record.user_id)
      end
      can :update, Record, user_id: user.id
      can :soft_destroy, Record, user_id: user.id
      cannot :destroy, Record

      # Tag
      can :create, Tag
      can :read, Tag, deleted: false
      can :update, Tag, user_id: user.id
      can :soft_destroy, user_id: user.id
      cannot :destroy, Tag
    else
      # not logged in
      cannot :manage, :all
      basic_read_only
    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
  protected
    def basic_read_only
    end
end
