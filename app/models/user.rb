class User < ActiveRecord::Base

  attr_accessible :username, :password, :name


  #has_many :followers, foreign_key: :following_id, class_name: 'Follow'#, inverse_of: :followed_user#, source: :follow
  #has_many :followees, foreign_key: :follower_id, class_name: 'Follow', source_type: "User"#, inverse_of: :followee_user#, source: :follow

  #has_many :follows
  #has_many :followers, :through => :follows, :source => :following
  #has_many :followees, :through => :follows, source: :user, foreign_key: :user_id




  has_many :follower_association, foreign_key: :following_id, class_name: 'Tweet::Follow'
  has_many :followers, through: :follower_association, source: :follower

  has_many :following_association, foreign_key: :follower_id, class_name: 'Tweet::Follow'
  has_many :followees, through: :following_association, source: :following

  has_many :tweet_tweets, foreign_key: :user_id, class_name: 'Tweet::Tweet', dependent: :destroy
  has_many :tweet_tweets_all, through: :tweet_tweets, source: :user

  #has_many :follows, foreign_key: 'user_id', dependent: :destroy
  #has_many :following_users, through: :follows, source: :following
  #has_many :follows, foreign_key: 'user_id', dependent: :destroy

  validates_presence_of :name, :username, :password
  validates_length_of :name, :maximum => 50
  validates_length_of :username, :maximum => 40
  validates_length_of :password, :minimum => 5, :maximum => 80
  validates_uniqueness_of :username
  validates_format_of :username, :with => /^[a-z][a-z0-9]*$/i, :message => "is invalid (only lowercase alphabets and numerals characters allowed)"
  validates_format_of :password, :with => /^[A-Za-z.$@&*!][A-Za-z0-9.$@&*!]*$/i, :message => "is invalid (only alphanumeric characters, $, @, *, ! and . allowed; first character must not be number)"


=begin
  def following?(other_user)
    follows.find_by_following_id(other_user.id)
  end

  def follow!(followed_user)
    follows.create!(following_id: followed_user.id)
  end

  def following_all
    follows.find_all_by_user_id(self.id)
  end

  def unfollow!(other_user)
    follows.find_by_following_id(other_user.id).destroy
  end

=begin
  def follower(follower_id=nil)
    @follower=follower_id
  end

  def followee(followee_id=nil)
    @followee=followee_id
  end

  before_save :check_follower, :check_followee

  def check_follower
    if @follower
      self.follow.create(@follower,self.id)
    end
  end

  def check_followee
    if @flwee
      Follow.create(self.id,@flwee)
    end
  end
=end
end
