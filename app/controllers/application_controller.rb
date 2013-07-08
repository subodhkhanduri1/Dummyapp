class ApplicationController < ActionController::Base
  def logged_in
    return true if session[:user_id]
  end

  def is_integer?(s)
    s.to_i.to_s==s
  end
end
