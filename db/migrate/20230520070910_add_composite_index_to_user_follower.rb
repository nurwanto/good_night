class AddCompositeIndexToUserFollower < ActiveRecord::Migration[5.0]
  def change
    add_index :user_followers, %i[followed_id follower_id], unique: true
  end
end
