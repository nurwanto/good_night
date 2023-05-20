module Api
  module V1
    class BedTimeController < ApplicationController
      def history
        render json: BedTimeHistory.first
      end
    end
  end
end
