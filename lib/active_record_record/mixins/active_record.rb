require 'active_record_record/helper'

module ActiveRecordRecord
  module Mixins
    module ActiveRecord
      def track_time_as(*args, &block)
        ActiveRecordRecord::Helper.track_time_as(*args, &block)
      end
    end
  end
end

