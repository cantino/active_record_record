require 'active_record_record/mixins/action_controller'
require 'active_record_record/mixins/active_record'

module ActiveRecordRecord
  class Railtie < Rails::Railtie
    ActiveSupport.on_load :action_controller do
      ActionController::Base.send :include, ActiveRecordRecord::Mixins::ActionController
    end

    ActiveSupport.on_load :active_record do
      ActiveRecord::Base.send :include, ActiveRecordRecord::Mixins::ActiveRecord
    end

    if ENV['COUNT_OBJECTS'] && Rails.env.development?
      config.after_initialize do
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

        ActiveRecord::ConnectionAdapters::QueryCache.class_eval do
          def select_all(arel, name = nil, binds = [])
            if @query_cache_enabled
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

        ActionController::Base.class_eval do
          before_filter :clear_ar_counts
          after_filter :print_ar_counts

          def clear_ar_counts
            Thread.current[:ar_counts] = {}
            Thread.current[:times] = {}
            Thread.current[:request_start_time] = Time.now
            Thread.current[:do_counts] = true
            Thread.current[:objects_key] = :default
          end

          def dump_counts(stat_data, out, prefix = '')
            printed_something = false

            sql_data = stat_data.delete(:sql_data)
            query_cache_data = stat_data.delete(:query_cache_data)
            render_data = stat_data.delete(:render_data)
            stat_data.to_a.sort { |a, b| b.last[:total] <=> a.last[:total] }.each do |klass, counts|
              out.puts "#{prefix}#{klass} (#{counts.delete(:total)} loads / #{counts.delete(:ids).uniq.length} unique):"
              counts.to_a.sort { |a, b| b.last <=> a.last }.each do |place, count|
                printed_something = true
                out.puts "#{prefix}  #{count}#{" " * ([0, 4 - count.to_s.length].max)}- #{place}"
              end
              out.puts
            end

            if render_data
              count = render_data.delete(:count)
              out.puts
              out.puts "#{prefix}#{count} Renders"

              render_data.to_a.sort { |a, b| (b.last[:duration]/b.last[:count].to_f) <=> (a.last[:duration]/a.last[:count].to_f) }.each do |place, data|
                out.puts "#{prefix}   #{data[:count]}#{" " * ([0, 4 - data[:count].to_s.length].max)}- #{place} (#{data[:duration]}s, average of #{data[:duration] / data[:count].to_f}s per render)"
              end

              out.puts
              out.puts
            end

            if sql_data
              count = sql_data.delete(:count)
              duration = sql_data.delete(:duration)
              out.puts
              out.puts "#{prefix}#{count} SQL Queries (totaling #{duration}s with an average of #{duration / count.to_f}s per query)"

              sql_data.to_a.sort { |a, b| b.last[:duration] <=> a.last[:duration] }.each do |place, data|
                out.puts "#{prefix}   #{data[:count]}#{" " * ([0, 4 - data[:count].to_s.length].max)}- #{place} (#{data[:duration]}s, average of #{data[:duration] / data[:count].to_f}s per query)"
                prefix2 = "#{prefix}   #{" " * data[:count].to_s.length}#{" " * ([0, 4 - data[:count].to_s.length].max)}"
                data[:queries].to_a.sort { |a, b| b.last[:duration] <=> a.last[:duration] }.each do |query, query_data|
                  out.puts "#{prefix2}   #{query_data[:count]}#{" " * ([0, 4 - query_data[:count].to_s.length].max)} - #{query} (#{query_data[:duration]}s total)"
                end
                out.puts
              end

              out.puts
            end

            if query_cache_data
              count = query_cache_data.delete(:count)
              out.puts
              out.puts "#{prefix}#{count} SQL Cache Queries"

              query_cache_data.to_a.sort { |a, b| b.last[:count] <=> a.last[:count] }.each do |place, data|
                out.puts "#{prefix}   #{data[:count]}#{" " * ([0, 4 - data[:count].to_s.length].max)}- #{place}"
                prefix2 = "#{prefix}   #{" " * data[:count].to_s.length}#{" " * ([0, 4 - data[:count].to_s.length].max)}"
                data[:queries].to_a.sort { |a, b| b.last <=> a.last }.each do |query, c|
                  out.puts "#{prefix2}   #{c}#{" " * ([0, 4 - c.to_s.length].max)} - #{query}"
                end
                out.puts
              end

              out.puts
              out.puts
            end

            printed_something
          end

          def print_ar_counts
            return if controller_name == 'page_not_found'
            path = "/tmp/#{Time.now.to_f}.counts.txt"
            tmp = File.open(path, "w")
            tmp.puts "ActiveRecord counts for request to #{controller_name}##{action_name}\n\n"
            printed_something = dump_counts(Thread.current[:ar_counts][:default], tmp)

            tmp.puts "Timings:"
            (Thread.current[:times] || {}).to_a.sort_by { |i| i.last[:sum] }.reverse.each do |key, obj|
              tmp.puts "\n\t#{key}\t\t#{obj[:sum]} seconds\t(#{obj[:count]} times with an average of #{obj[:sum] / obj[:count]} seconds)"

              if Thread.current[:ar_counts][key]
                dump_counts(Thread.current[:ar_counts][key], tmp, "\t\t\t")
              end

              printed_something = true
            end

            if printed_something
              tmp.puts
              tmp.puts "Request took approximately #{Time.now.to_f - Thread.current[:request_start_time].to_f} seconds."
              tmp.close
              system("open #{path} -t -g")
            else
              tmp.close
              File.unlink path
            end
          end
        end
      end
    end
  end
end