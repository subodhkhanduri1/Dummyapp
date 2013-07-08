require 'spec_helper'

def valid_password
  l = rand(75)+5
  i = 0
  alpha_symbols = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.$@&*!"
  all_valid_characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.$@&*!0123456789"
  str = ""
  while i < l do
    if(i==0)
      str = alpha_symbols[rand(57)]
    else
      str << "#{all_valid_characters[rand(67)]}"
    end
    i+=1
  end
  return str
end

def invalid_password(l)
  i = 0
  alpha_symbols = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.$@&*!"
  all_valid_characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.$@&*!0123456789"
  str = ""
  while i < l do
    if(i==0)
      str = alpha_symbols[rand(57)]
    else
      str << "#{all_valid_characters[rand(67)]}"
    end
    i+=1
  end
  return str
end

def invalid_password_characters
  i = 0
  l = rand(75)+5
  invalid_symbols = "#%^()"
  str = ""
  while i < l do
    if(i==0)
      str = invalid_symbols[rand(4)]
    else
      str << "#{invalid_symbols[rand(4)]}"
    end
    i+=1
  end
  return str
end

def valid_username
  i = 0
  l = rand(35)+5
  alpha_symbols = "abcdefghijklmnopqrstuvwxyz"
  all_valid_characters = "abcdefghijklmnopqrstuvwxyz0123456789"
  str = ""
  while i < l do
    if(i==0)
      str = alpha_symbols[rand(25)]
    else
      str << "#{all_valid_characters[rand(35)]}"
    end
    i+=1
  end
  return str
end

def invalid_username_length(l)
  i = 0
  alpha_symbols = "abcdefghijklmnopqrstuvwxyz"
  all_valid_characters = "abcdefghijklmnopqrstuvwxyz0123456789"
  str = ""
  while i < l do
    if(i==0)
      str = alpha_symbols[rand(25)]
    else
      str << "#{all_valid_characters[rand(35)]}"
    end
    i+=1
  end
  return str
end

def invalid_username_characters
  i = 0
  l = rand(35)+5
  valid_alpha_symbols = "abcdefghijklmnopqrstuvwxyz"
  invalid_characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ.$@&*!"
  str = ""
  while i < l do
    if(i==0)
      str = valid_alpha_symbols[rand(25)]
    else
      str << "#{invalid_characters[rand(35)]}"
    end
    i+=1
  end
  return str
end

describe User do

  it "has a valid factory" do
    FactoryGirl.create(:user).should be_valid
  end

  it "is invalid without a name" do
    FactoryGirl.build(:user,name: nil).should_not be_valid
  end

  it "is invalid without a username" do
    FactoryGirl.build(:user,username: nil).should_not be_valid
  end

  it "is invalid without a password" do
    FactoryGirl.build(:user,password: nil).should_not be_valid
  end

  it "has a valid name" do

  end

  it "has a valid username" do
    FactoryGirl.build(:user,username: valid_username()).should be_valid
    FactoryGirl.build(:user,username: invalid_username_length(41)).should_not be_valid
    FactoryGirl.build(:user,username: invalid_username_characters()).should_not be_valid
  end

  it "has a valid password" do
    FactoryGirl.build(:user,password: valid_password()).should be_valid
    FactoryGirl.build(:user,password: invalid_password(4)).should_not be_valid
    FactoryGirl.build(:user,password: invalid_password(81)).should_not be_valid
    FactoryGirl.build(:user,password: invalid_password_characters()).should_not be_valid
  end

end