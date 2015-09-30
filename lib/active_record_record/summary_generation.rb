module ActiveRecordRecord
  module SummaryGeneration
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

