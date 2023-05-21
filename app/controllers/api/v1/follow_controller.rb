module Api
  module V1
    class FollowController < ApplicationController
      protect_from_forgery with: :null_session

      def action
        if params[:current_user_id].blank?
          return render json: { error_message: 'current_user_id should be exist' },
                        status: :bad_request
        end

        if params[:target_user_id].blank?
          return render json: { error_message: 'target_user_id should be exist' },
                        status: :bad_request
        end

        if params[:target_user_id] == params[:current_user_id]
          return render json: { error_message: 'you cannot follow yourself' },
                        status: :bad_request
        end

        current_user = User.find_by(id: params[:current_user_id])
        if current_user.blank?
          return render json: { error_message: "user_id #{params[:current_user_id]} not exist" },
                        status: :not_found
        end

        target_user = User.find_by(id: params[:target_user_id])
        if target_user.blank?
          return render json: { error_message: "target_user_id #{params[:target_user_id]} not exist" },
                        status: :not_found
        end

        case params&.dig(:follow, :action).to_s
        when 'follow'
          if UserFollower.find_by(follower_id: current_user.id, followed_id: target_user.id).present?
            return render json: { error_message: "you are already following user #{target_user.id}" },
                          status: :bad_request
          end
          UserFollower.create!(follower_id: current_user.id, followed_id: target_user.id)
        when 'unfollow'
          user_follower = UserFollower.find_by(follower_id: current_user.id, followed_id: target_user.id)
          if user_follower.present?
            user_follower.destroy!
          else
            return render json: { error_message: "you are already following user #{target_user.id}" },
                          status: :bad_request
          end
        else
          return render json: { error_message: 'action should be exist, accepted value ["follow", "unfollow"]' },
                        status: :bad_request
        end

        render json: { message: "you have successfully #{params&.dig(:follow, :action)} user #{target_user.id}" }
      end

      def get_followers
        if params[:current_user_id].blank?
          return render json: { error_message: 'current_user_id should be exist' },
                        status: :bad_request
        end

        current_user = User.find_by(id: params[:current_user_id])
        if current_user.blank?
          render json: { error_message: "user_id #{params[:current_user_id]} not exist" },
                 status: :not_found
        end

        render json: { data: current_user.followers }
      end

      def get_followed
        if params[:current_user_id].blank?
          return render json: { error_message: 'current_user_id should be exist' },
                        status: :bad_request
        end

        current_user = User.find_by(id: params[:current_user_id])
        if current_user.blank?
          render json: { error_message: "user_id #{params[:current_user_id]} not exist" },
                 status: :not_found
        end

        render json: { data: current_user.followed }
      end
    end
  end
end
