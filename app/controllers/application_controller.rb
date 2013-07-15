class ApplicationController < ActionController::Base
  def logged_in
    return true if session[:user_id]
  end

  def drop_back_home
    if logged_in
      redirect_to tweet.tweet_index_path and return
    end
  end

  def authenticate
    if !logged_in
      redirect_to new_user_path and return
    end
  end

  def current_user
    User.find_last_by_id(session[:user_id])
  end

  def is_integer?(s)
    s.to_i.is_a?(Fixnum || Integer)
  end
end
