require 'spec_helper'

describe UserController do

   describe "POST #login" do

     it "should_redirect_to_home_page_if_logged_in" do
       user = FactoryGirl.create(:user, username: "subodh", password: "shubham")
       session[:user_id] = user.id
       post :login, username: user.username, password: user.password, submit: :submit
       response.should redirect_to("/tweet/tweet/home")
     end

     context "with_valid_attributes" do

       it "sets_up_the_session" do
         user = FactoryGirl.create(:user, username: "subodh", password: "shubham")
         post :login, username: user.username, password: user.password, submit: :submit
         session[:user_id].should equal(user.id)
       end

       it "redirects_to_home_page" do
         user = FactoryGirl.create(:user, username: "subodh", password: "shubham")
         post :login, username: user.username, password: user.password, submit: :submit
         response.should redirect_to("/tweet/tweet/home")
       end

     end

     context "with_invalid_attributes" do

       it "renders_login_page" do
         user = FactoryGirl.create(:user, username: "subodh", password: "shubham")
         post :login, username: "ajgdasjgfk", password: "asvhka", submit: :submit
         response.should render_template :login
       end

     end

   end

   describe "POST #sign_up" do

     it "should_redirect_to_home_page_if_logged_in" do
       user = FactoryGirl.create(:user, username: "subodh", password: "shubham")
       session[:user_id] = user.id
       post :sign_up, name: user.name, username: user.username, password: user.password, re_password: user.password, commit: :submit
       response.should redirect_to("/tweet/tweet/home")
     end

     context "with_valid_attributes" do
       it "sets_up_the_session" do
         user = FactoryGirl.build(:user, username: "subodh", password: "shubham")
         post :sign_up, name: user.name, username: user.username, password: user.password, re_password: user.password, commit: :submit
         session[:user_id].should equal(User.where(username: user.username).first.id)
       end

       it "redirects_to_home_page" do
         user = FactoryGirl.build(:user)
         post :sign_up, name: user.name, username: user.username, password: user.password, re_password: user.password, commit: :submit
         response.should redirect_to("/tweet/tweet/home")
       end

     end

     context "with_invalid_attributes" do
       it "renders_sign_up page" do
         user = FactoryGirl.build(:user, username: "subodh afasf", password: "shubham")
         post :sign_up, name: user.name, username: user.username, password: user.password, re_password: user.password, commit: :submit
         response.should render_template :sign_up
       end
     end

   end

   describe "POST #logout" do

     it "should_redirect_to_login_page_if_not_logged_in" do
       post :logout, logout: :logout
       response.should redirect_to("/user/login")
     end

     it "should_destroy_session" do
       user = FactoryGirl.create(:user, username: "subodh", password: "shubham")
       post :login, username: user.username, password: user.password, submit: :submit
       session[:user_id].should equal(user.id)
       post :logout, logout: :logout
       session[:user_id].should be(nil)
     end

     it "should_render_logout_page" do
       user = FactoryGirl.create(:user, username: "subodh", password: "shubham")
       post :login, username: user.username, password: user.password, submit: :submit
       session[:user_id].should equal(user.id)
       post :logout, logout: :logout
       session[:user_id].should be(nil)
       response.should render_template :logout
     end

   end

   describe "GET #all_users" do

     it "should_redirect_to_login_page_if_not_logged_in" do
       get :all_users
       response.should redirect_to("/user/login")
     end

     it "populates_the_users_array" do
       user = FactoryGirl.create(:user)
       get :all_users
       assigns(:users).should eq([user])
     end

   end

end