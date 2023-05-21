module Api
  module V1
    class BedTimeController < ApplicationController
      def history
        # current_user variable is to simulate authentication and detect the account
        if params[:current_user_id].blank?
          return render json: { error_message: 'current_user should be exist' },
                        status: :bad_request
        end

        current_user = User.find(params[:current_user_id])
        if current_user.blank?
          return render json: { error_message: "user_id #{params[:current_user_id]} not exist" },
                        status: :not_found
        end

        followers = if params[:user_id].present?
                      current_user.followers.where(id: params[:user_id])
                    else
                      current_user.followers
                    end

        if followers.blank?
          return render json: { error_message: 'empty followers' },
                        status: :not_found
        end

        data = []
        followers.each do |follower|
          bed_time_histories = follower.bed_time_histories.map do |x|
            { bed_time: x.bed_time, wake_up_time: x.wake_up_time, duration: (x.wake_up_time - x.bed_time) }
          end

          bed_time_histories = bed_time_histories.sort_by { |x| x[:duration] }

          data << {
            user_id: follower.id,
            user_name: follower.name,
            bed_time_histories: bed_time_histories
          }
        end

        render json: { data: data }
      end
    end
  end
end
