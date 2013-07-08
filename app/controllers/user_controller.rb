class UserController < ApplicationController
=begin
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.save
  end
=end
  def check_login
    if session[:user_id]
      redirect_to "/tweet/tweet/home" and return
    end
  end

  def logged_in
    if session[:user_id]
      return true
    end
  end

  def login
=begin
    if session[:user_id]
      redirect_to action: :home and return
    end
=end
    @title = "Welcome"
    if logged_in
      redirect_to "/tweet/tweet/home" and return
    else
      if params[:submit]
        @user = User.find_last_by_username(params[:username])

        if @user
          if @user.username.to_s==params[:username].to_s && @user.password.to_s==params[:password].to_s
            session[:user_id]=@user.id
            redirect_to "/tweet/tweet/home" and return
          end
        end
        @error=true;
        #redirect_to action: :login and return
      end
    end
  end

  def sign_up
    @title = "Welcome"
    if logged_in
      redirect_to "/tweet/tweet/home" and return
    else
      if params[:back]
        redirect_to  action: :login and return
      end
      if params[:commit]
        if params[:password].to_s==params[:re_password]
          @user=User.new(:name => params[:name], :username => params[:username], :password => params[:password])
          @user.save
          if !@user.errors.blank?
            @messages = @user.errors.full_messages
          else
            #@message = "User '#{@user.username}' successfully created"
            session[:user_id] = User.where(username: params[:username]).first.id
            redirect_to "/tweet/tweet/home" and return
          end
        else
          @message = 'New Passwords dont match'
        end
      end
    end

  end

  def profile
    if logged_in
      if params[:user] && is_integer?(params[:user]) && User.exists?(id: params[:user])
        @userpro = User.find(params[:user])
        @user = User.find(session[:user_id])
        if params[:per_page] && is_integer?(params[:per_page]) && params[:per_page].to_i>15
          per_page = params[:per_page]
        else
          per_page = 15
        end
        if params[:page] && is_integer?(params[:page]) && params[:page].to_i>0
          page = params[:page]
        else
          page = 1
        end
        @tweets = Tweet::Tweet.where(user_id: @userpro.id).paginate(per_page: per_page, page: page, order: 'created_at DESC')
        @followers = @userpro.followers.order("created_at ASC").limit(5)
        @no_of_followers = @userpro.followers.size
        @followees = @userpro.followees.order("created_at DESC").limit(5)
        @no_of_followees = @userpro.followees.size
        @title = "#{userpro.name}'s Profile"
      else
        redirect_to path: "/tweet/tweet/home" and return
      end
    else
      redirect_to action: :login and return
    end
  end

  def logout
    if session[:user_id]
      if params[:logout]
        session.delete(:user_id)
        @title = "See you soon"
      else
        redirect_to "/tweet/tweet/home" and return
      end
    else
      redirect_to action: :login and return
    end
  end

  def edit_profile
    if session[:user_id]
      @user = User.find_last_by_id(session[:user_id])
      @title = "Your Profile"
    else
      redirect_to action: :login and return
    end
  end

  def change_password
    if session[:user_id]
      if params[:back]
        redirect_to action: :edit_profile and return
      end
      @user = User.find(session[:user_id])
      @title = "Your Profile"
      if params[:commit]
        if(params[:new_password].to_s==params[:re_password].to_s)
          if params[:old_password].to_s==@user.password.to_s
            @user.password = params[:new_password]
            @user.save
            if @user.errors.full_messages.size>0
              session[:messages] = @user.errors.full_messages
            else
              @message='Password successfully changed'
            end
          else
            @message='Invalid Password'
          end
        else
          @message='New Passwords dont match'
        end
      end
    else
      redirect_to action: :login and return
    end
  end

  def change_name
    if logged_in
      if params[:back]
        redirect_to action: :edit_profile and return
      end
      @user = User.find(session[:user_id])
      @title = "Your Profile"
      if params[:commit]
          if params[:name]
            @user.name = params[:name]
            @user.save
            if @user.errors.full_messages.size>0
              session[:messages] = @user.errors.full_messages
            end
            @message='Name successfully changed'
          end
      end
    else
      redirect_to action: :login and return
    end
  end




=begin
  def all_users
    if logged_in
      @user = User.find(session[:user_id])
      if params[:page_id] && is_integer?(params[:page_id])
        @users = User.where(User.arel_table[:id].not_eq(session[:user_id])).order("name ASC").limit(20).offset((params[:page_id].to_i-1)*20)
      elsif params[:page_id] && !is_integer?(params[:page_id])
        redirect_to action: :all_users and return
      else
        @users = User.where(User.arel_table[:id].not_eq(session[:user_id])).order("name ASC").limit(20)
      end
    else
      redirect_to action: :login and return
    end
  end
=end

  def all_users
    if logged_in
      @user = User.find(session[:user_id])
      if params[:per_page] && is_integer?(params[:per_page]) && params[:per_page].to_i>15
        per_page = params[:per_page]
      else
        per_page = 10
      end
      if params[:page] && is_integer?(params[:page]) && params[:page].to_i>0
        page = params[:page]
      else
        page = 1
      end
      @users = User.where(User.arel_table[:id].not_eq(session[:user_id])).paginate(per_page: per_page, page: page, order: 'name')
    else
      redirect_to action: :login and return
    end
  end

end
