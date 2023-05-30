module Api
  module V1
    class BedTimeController < ApplicationController
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

      def history
        authenticate!

        # TODO: add pagination
        sql_query = "SELECT bth.id, bth.user_id, bth.bed_time, bth.wake_up_time, ROUND((JULIANDAY(bth.wake_up_time) - JULIANDAY(bth.bed_time)) * 86400) as duration FROM user_followers uf INNER JOIN bed_time_histories bth ON bth.user_id = uf.followed_id WHERE bth.created_at >= \"#{10.week.ago}\" AND uf.follower_id = #{@current_user.id} ORDER BY duration DESC"
        data = ActiveRecord::Base.connection.execute(sql_query)

        render json: { data: data&.map do |x|
                               { id: x['id'], user_id: x['user_id'], bed_time: x['bed_time'],
                                 wake_up_time: x['wake_up_time'], duration: x['duration'] }
                             end }
      end

      def set_unset
        authenticate!

        system_time = Time.now
        case params[:type].to_s
        when 'bed_time'
          unless @current_user.bed_time_histories&.last&.wake_up_time.present?
            raise StandardError, "you haven't woken up yet"
          end

          BedTimeHistory.create!(bed_time: system_time, user_id: @current_user.id)
        when 'wake_up'
          last_history = current_user.bed_time_histories&.last
          unless last_history&.bed_time.present? && last_history&.wake_up_time.blank?
            raise StandardError, "you haven't slept yet"
          end

          last_history.update!(wake_up_time: system_time)
        else
          raise StandardError, 'type should be exist, accepted value ["bed_time", "wake_up"]'
        end

        render json: { message: "#{params[:type]} has been successfully updated at #{system_time}" }
      end
    end
  end
end
