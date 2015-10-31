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

    def print_ar_counts(formatter = TextFormatter)
      return if controller_name == 'page_not_found'
      temp_file, path = open_temp_file
      temp_file.puts "ActiveRecord counts for request to #{controller_name}##{action_name}\n\n"

      printed_something, default_text  = formatter.format(Thread.current[:ar_counts][:default])
      temp_file.puts(text) unless default_text.empty?

      temp_file.puts "Timings:"
      (Thread.current[:times] || {}).to_a.sort_by { |i| i.last[:sum] }.reverse.each do |key, obj|
        temp_file.puts "\n\t#{key}\t\t#{obj[:sum]} seconds\t(#{obj[:count]} times with an average of #{obj[:sum] / obj[:count]} seconds)"

        if Thread.current[:ar_counts][key]
          _, custom_text = formatter.format(Thread.current[:ar_counts][key], "\t\t\t")
          temp_file.puts(text) unless custom_text.empty?
        end

        printed_something = true
      end

      if printed_something
        temp_file.puts
        temp_file.puts "Request took approximately #{Time.now.to_f - Thread.current[:request_start_time].to_f} seconds."
        temp_file.close
        system("open #{path} -t -g")
      else
        close_temp_file(temp_file, path)
      end
    end

    private

    def open_temp_file
      path = "/tmp/#{Time.now.to_f}.counts.txt"
      temp_file = File.open(path, "w")
      return temp_file, path
    end

    def close_temp_file(tem_file, path)
      temp_file.close
      File.unlink path
    end
  end
end

