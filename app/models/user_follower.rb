class UserFollower < ApplicationRecord
  validates_uniqueness_of :followed_id, scope: :follower_id
end
