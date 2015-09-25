require 'active_record_record/summary_generation'

module ActiveActiveRecordRecord
  module MonkeyPatcher
    def self.instrument_renders!
      ActionView::Renderer.module_eval do
        def render_with_time_logging(context, options, &block)
          start_time = Time.now.to_f
          render_without_time_logging(context, options, &block).tap do
            if Thread.current[:do_counts]
              place = Helper.clean_trace(caller)
              duration = Time.now.to_f - start_time
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

        alias_method_chain :render, :time_logging
      end
    end

    def self.instrument_query_cache!
      ActiveRecord::ConnectionAdapters::QueryCache.class_eval do
        def select_all(arel, name = nil, binds = [])
          if @query_cache_enabled && !locked?(arel)
            sql = to_sql(arel, binds)

            if @query_cache[sql].key?(binds)
              if Thread.current[:do_counts]
                place = Helper.clean_trace(caller)
                cleaned_query = Helper.clean_queries(sql)
                key = Thread.current[:objects_key]

                Thread.current[:ar_counts] ||= {}
                Thread.current[:ar_counts][key] ||= {}
                Thread.current[:ar_counts][key][:query_cache_data] ||= {}
                Thread.current[:ar_counts][key][:query_cache_data][:count] ||= 0
                Thread.current[:ar_counts][key][:query_cache_data][:count] += 1

                Thread.current[:ar_counts][key][:query_cache_data][place] ||= {}
                Thread.current[:ar_counts][key][:query_cache_data][place][:count] ||= 0
                Thread.current[:ar_counts][key][:query_cache_data][place][:count] += 1
                Thread.current[:ar_counts][key][:query_cache_data][place][:queries] ||= {}
                Thread.current[:ar_counts][key][:query_cache_data][place][:queries][cleaned_query] ||= 0
                Thread.current[:ar_counts][key][:query_cache_data][place][:queries][cleaned_query] += 1
              end
            end

            cache_sql(sql, binds) { super(sql, name, binds) }
          else
            super
          end
        end
      end
    end

    def self.instrument_mysql_adapter!
      ActiveRecord::ConnectionAdapters::Mysql2Adapter.class_eval do
        def execute_with_logging(*args, &block)
          start = Time.now.to_f
          execute_without_logging(*args, &block).tap do
            if Thread.current[:do_counts] && args.last != :skip_logging
              place = Helper.clean_trace(caller)
              cleaned_query = Helper.clean_queries(args.first)
              duration = Time.now.to_f - start
              key = Thread.current[:objects_key]

              Thread.current[:ar_counts] ||= {}
              Thread.current[:ar_counts][key] ||= {}
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

        alias_method_chain :execute, :logging
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
        include ActiveActiveRecordRecord::SummaryGeneration

        before_filter :clear_ar_counts
        after_filter :print_ar_counts
      end
    end
  end
end
