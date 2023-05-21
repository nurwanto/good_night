module Api
  module V1
    class BedTimeController < ApplicationController
      def history
        # TODO: add params validation, error handling if data empty

        # current_user variable is to simulate authentication and detect the account
        current_user = User.find(params[:current_user_id])

        followers = if params[:user_id].present?
                      current_user.followers.where(id: params[:user_id])
                    else
                      current_user.followers
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
