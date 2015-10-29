require_relative "text_formatter"

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
      out.puts TextFormatter.format(stat_data, prefix = '')
    end

    def print_ar_counts
      return if controller_name == 'page_not_found'
      tmp, path = open_temp_file
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
        close_temp_file(tmp, path)
      end
    end

    def open_temp_file
      path = "/tmp/#{Time.now.to_f}.counts.txt"
      tmp = File.open(path, "w")
      return tmp, path
    end

    def close_temp_file(tem_file, path)
      temp_file.close
      File.unlink path
    end
  end
end

