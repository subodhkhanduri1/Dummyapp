class UserController < ApplicationController

  before_filter :authenticate

  before_filter :drop_back_home, only: [:new, :create]

  skip_before_filter :authenticate, only: [:new,:create]

  def new
    @title = "Welcome"
    if params[:submit]
      @user = User.where(username: params[:username], password: params[:password]).first
      if not @user.blank?
        session[:user_id]=@user.id
        redirect_to tweet.tweet_index_path and return
      end
      @error=true;
    end
  end

  def create
    @title = "Welcome"
    if params[:commit]
      if params[:password].to_s==params[:re_password]
        @user=User.new(:name => params[:name], :username => params[:username], :password => params[:password])
        @user.save
        if !@user.errors.blank?
          @messages = @user.errors.full_messages
          render template: "user/new"
        else
          session[:user_id] = User.where(username: params[:username]).first.id
          redirect_to tweet.tweet_index_path and return
        end
      else
        @message = 'New Passwords dont match'
        render template: "user/new"
      end
    end
  end

  def show
    if params[:id] && is_integer?(params[:id]) && User.exists?(id: params[:id])
      @userpro = User.find(params[:id])
      @user = current_user
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
      @title = "#{@userpro.name}'s Profile"
    else
      redirect_to tweet.tweet_index_path and return
    end
  end

  def destroy
    if params[:logout]
      session.delete(:user_id)
      @title = "See you soon"
    else
      redirect_to tweet.tweet_index_path and return
    end
  end

  def edit
    @user = current_user
    @title = "Your Profile"
  end

  def change_password
    if params[:back]
      redirect_to edit_user_path(session[:user_id])
    end
    @user = current_user
    @title = "Your Profile"
    if params[:commit]
      if(params[:new_password].to_s==params[:re_password].to_s)
        if params[:old_password].to_s==@user.password.to_s
          @user.password = params[:new_password]
          @user.save
          if @user.errors.full_messages.size>0
            session[:messages] = @user.errors.full_messages
          else
            @message='<span style="color:green">Password successfully changed</span>'.html_safe
          end
        else
          @message='Invalid Password'
        end
      else
        @message='New Passwords dont match'
      end
    end
  end

  def change_name
    if params[:back]
      redirect_to edit_user_path(session[:user_id])
    end
    @user = current_user
    @title = "Your Profile"
    if params[:commit]
        if params[:name]
          @user.name = params[:name]
          @user.save
          if @user.errors.full_messages.size>0
            session[:messages] = @user.errors.full_messages
          end
          @message='<span style="color:green">Name successfully changed</span>'.html_safe
        end
    end
  end


  def index
    @title = "All Users"
    @user = current_user
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
  end
end
