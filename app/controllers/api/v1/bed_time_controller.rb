module Api
  module V1
    class BedTimeController < ApplicationController
      protect_from_forgery with: :null_session

      def history
        # current_user variable is to simulate authentication and detect the account
        if params[:current_user_id].blank?
          return render json: { error_message: 'current_user_id should be exist' },
                        status: :bad_request
        end

        current_user = User.find_by(id: params[:current_user_id])
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

      def set_unset
        if params[:current_user_id].blank?
          return render json: { error_message: 'current_user_id should be exist' },
                        status: :bad_request
        end

        current_user = User.find_by(id: params[:current_user_id])
        if current_user.blank?
          return render json: { error_message: "user_id #{params[:current_user_id]} not exist" },
                        status: :not_found
        end

        case params[:type].to_s
        when 'bed_time'
          if current_user.bed_time_histories&.last&.wake_up_time.present?
            BedTimeHistory.create!(bed_time: Time.now, user_id: current_user.id)
          else
            return render json: { error_message: "you haven't woken up yet" },
                          status: :bad_request
          end
        when 'wake_up'
          last_history = current_user.bed_time_histories&.last
          if last_history&.bed_time.present? && last_history&.wake_up_time.blank?
            last_history.update!(wake_up_time: Time.now)
          else
            return render json: { error_message: "you haven't slept yet" },
                          status: :bad_request
          end
        else
          return render json: { error_message: 'type should be exist, accepted value ["bed_time", "wake_up"]' },
                        status: :bad_request
        end

        render json: { message: "#{params[:type]} has been successfully updated" }
      end
    end
  end
end
