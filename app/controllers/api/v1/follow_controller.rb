module Api
  module V1
    class FollowController < ApplicationController
      include Api::V1::GeneralHelper
      protect_from_forgery with: :null_session

      rescue_from ArgumentError do |e|
        render json: { error_message: e.message },
               status: :not_found
      end

      rescue_from StandardError do |e|
        render json: { error_message: e.message },
               status: :bad_request
      end

      rescue_from ActiveRecord::RecordNotFound do |e|
        render json: { error_message: e.message },
               status: :not_found
      end

      def action
        authenticate!

        raise StandardError, 'target_user_id should be exist' if params[:target_user_id].blank?
        raise StandardError, 'you cannot follow yourself' if params[:target_user_id] == params[:current_user_id]

        target_user = User.find(params[:target_user_id])

        case params&.dig(:follow, :action).to_s
        when 'follow'
          raise StandardError, "you are already following user #{target_user.id}" if UserFollower.find_by(
            follower_id: current_user.id, followed_id: target_user.id
          )

          UserFollower.create!(follower_id: current_user.id, followed_id: target_user.id)
        when 'unfollow'
          user_follower = UserFollower.find_by(follower_id: current_user.id, followed_id: target_user.id)
          raise StandardError, "you are not following user #{target_user.id}" if user_follower.blank?

          user_follower.destroy!
        else
          raise StandardError, 'action should be exist, accepted value ["follow", "unfollow"]'
        end

        render json: { message: "you have successfully #{params&.dig(:follow, :action)} user #{target_user.id}" }
      end

      def get_followers
        authenticate!

        render json: { data: current_user.followers }
      end

      def get_followed
        authenticate!

        render json: { data: current_user.followed }
      end
    end
  end
end
