class PermissionsService
  attr_reader :user, :controller, :action

  def initialize(user)
    @user = user
  end

  def allow?(controller, action)
    @controller = controller
    @action     = action

    case
    when user && user.platform_admin?
      platform_admin_permissions
    when user && user.store_admin?
      store_admin_permissions
    else
      guest_user_permissions
    end
  end

  private

  def platform_admin_permissions
    return true if controller.in?(%w(items orders users))

    #return true if controller == 'items'
    #return true if controller == 'orders'
    #return true if controller == 'users'
  end

  def store_admin_permissions
    return true if controller.in?(%w(items orders sessions stores))
  end

  def guest_user_permissions
    return true if controller == 'stores' && action.in?(['index'])
    return true if controller == 'sessions'
  end
end
