# This migration comes from tweet (originally 20130703101905)
class CreateTweetTweets < ActiveRecord::Migration
  def change
    create_table :tweet_tweets do |t|
      t.column :user_id, :integer, :null => false
      t.column :message, :text, :limit => 200, :null => false
      t.timestamps
    end
  end
end
