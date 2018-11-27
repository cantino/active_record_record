require 'active_record_record/summary_generation'

module ActiveRecordRecord
  module MonkeyPatcher
    def self.instrument_renders!
      ActiveSupport::Notifications.subscribe(/\Arender_(partial|template)\.action_view\z/) do |_name, start, finish, _id, payload|
        if Thread.current[:do_counts]
          place = Helper.clean_trace([payload[:identifier]] + caller)
          duration = finish.to_f - start.to_f
          key = Thread.current[:objects_key]

          Thread.current[:ar_counts] ||= {}
          Thread.current[:ar_counts][key] ||= {}
          Thread.current[:ar_counts][key][:render_data] ||= {}
          Thread.current[:ar_counts][key][:render_data][:count] ||= 0
          Thread.current[:ar_counts][key][:render_data][:count] += 1

          Thread.current[:ar_counts][key][:render_data][place] ||= {}
          Thread.current[:ar_counts][key][:render_data][place][:count] ||= 0
          Thread.current[:ar_counts][key][:render_data][place][:count] += 1
          Thread.current[:ar_counts][key][:render_data][place][:duration] ||= 0
          Thread.current[:ar_counts][key][:render_data][place][:duration] += duration
        end
      end
    end

    def self.instrument_database_adapter!
      ActiveSupport::Notifications.subscribe('sql.active_record') do |_name, start, finish, _id, payload|
        if Thread.current[:do_counts] && !%w[COMMIT BEGIN].include?(payload[:sql])
          place = Helper.clean_trace(caller)
          cleaned_query = Helper.clean_queries(payload[:sql])
          key = Thread.current[:objects_key]
          Thread.current[:ar_counts] ||= {}
          Thread.current[:ar_counts][key] ||= {}

          if payload[:name] == 'SCHEMA'
            # ignore
          elsif payload[:name] == 'CACHE'
            Thread.current[:ar_counts][key][:query_cache_data] ||= {}
            Thread.current[:ar_counts][key][:query_cache_data][:count] ||= 0
            Thread.current[:ar_counts][key][:query_cache_data][:count] += 1

            Thread.current[:ar_counts][key][:query_cache_data][place] ||= {}
            Thread.current[:ar_counts][key][:query_cache_data][place][:count] ||= 0
            Thread.current[:ar_counts][key][:query_cache_data][place][:count] += 1
            Thread.current[:ar_counts][key][:query_cache_data][place][:queries] ||= {}
            Thread.current[:ar_counts][key][:query_cache_data][place][:queries][cleaned_query] ||= 0
            Thread.current[:ar_counts][key][:query_cache_data][place][:queries][cleaned_query] += 1
          else
            duration = finish.to_f - start.to_f

            Thread.current[:ar_counts][key][:sql_data] ||= {}
            Thread.current[:ar_counts][key][:sql_data][:count] ||= 0
            Thread.current[:ar_counts][key][:sql_data][:count] += 1
            Thread.current[:ar_counts][key][:sql_data][:duration] ||= 0
            Thread.current[:ar_counts][key][:sql_data][:duration] += duration

            Thread.current[:ar_counts][key][:sql_data][place] ||= {}
            Thread.current[:ar_counts][key][:sql_data][place][:count] ||= 0
            Thread.current[:ar_counts][key][:sql_data][place][:count] += 1
            Thread.current[:ar_counts][key][:sql_data][place][:duration] ||= 0
            Thread.current[:ar_counts][key][:sql_data][place][:duration] += duration
            Thread.current[:ar_counts][key][:sql_data][place][:queries] ||= {}
            Thread.current[:ar_counts][key][:sql_data][place][:queries][cleaned_query] ||= {:count => 0, :duration => 0}
            Thread.current[:ar_counts][key][:sql_data][place][:queries][cleaned_query][:count] += 1
            Thread.current[:ar_counts][key][:sql_data][place][:queries][cleaned_query][:duration] += duration
          end
        end
      end
    end

    def self.log_model_instantiation!
      ActiveRecord::Base.class_eval do
        after_initialize :log_initialize

        def log_initialize
          if Thread.current[:do_counts] && !new_record?
            place = Helper.clean_trace(caller)
            key = Thread.current[:objects_key]
            klass = self.class.to_s

            Thread.current[:ar_counts] ||= {}
            Thread.current[:ar_counts][key] ||= {}
            Thread.current[:ar_counts][key][klass] ||= {}
            Thread.current[:ar_counts][key][klass][:total] ||= 0
            Thread.current[:ar_counts][key][klass][:total] += 1
            Thread.current[:ar_counts][key][klass][place] ||= 0
            Thread.current[:ar_counts][key][klass][place] += 1
            Thread.current[:ar_counts][key][klass][:ids] ||= []
            Thread.current[:ar_counts][key][klass][:ids] << id
          end
        end
      end
    end

    def self.hook_request_cycle!
      ActionController::Base.class_eval do
        include ActiveRecordRecord::SummaryGeneration

        before_action :clear_ar_counts
        after_action :print_ar_counts
      end
    end
  end
end
