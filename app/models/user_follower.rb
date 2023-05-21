class UserFollower < ApplicationRecord
  belongs_to :follower, class_name: 'User', foreign_key: :follower_id

  validates_uniqueness_of :followed_id, scope: :follower_id
end
