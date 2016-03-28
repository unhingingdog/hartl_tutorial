module SessionsHelper

  def log_in(user)
    session[:user_id] = user.id
  end

  #remembers a user in a persistent session
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  #returns the current logged-in user (if any)
  def current_user
    if (user_id = session[:user_id])
      @current_user ||=  User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  #returns true if the given user is the logged in user
  def current_user?(user)
    user == @current_user
  end


#returns true if the user is logged in, flase otherwise
  def logged_in?
    !current_user.nil?
  end

  #forgets a user in a persistent session
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  #Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  #stores the URL for friendly forwarding of  logged out user trying to edit
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end

  #redirects to default (user path) or  stored location
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
end
