require 'active_record_record/helper'

module ActiveRecordRecord
  module Mixins
    module ActionController
      def track_time_as(*args, &block)
        ActiveRecordRecord::Helper.track_time_as(*args, &block)
      end

      def self.included(klass)
        klass.helper_method :track_time_as
      end
    end
  end
end

