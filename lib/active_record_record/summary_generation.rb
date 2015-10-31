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

    def print_ar_counts(options = {})
      return if controller_name == 'page_not_found'
      path      = "/tmp/#{Time.now.to_f}.counts.txt"
      formatter = options.fetch(:formatter, TextFormatter)
      tree      = options.fetch(:tree, Thread.current)
      file      = options.fetch(:file, File.open(path, "w"))
      time      = options.fetch(:time_class, Time)

      if options[:file]
        file_given = true
      end


      file.puts "ActiveRecord counts for request to #{controller_name}##{action_name}\n\n"

      printed_something, default_text  = formatter.format(tree[:ar_counts][:default])
      file.puts(default_text) unless default_text.empty?

      file.puts "Timings:"
      (tree[:times] || {}).to_a.sort_by { |i| i.last[:sum] }.reverse.each do |key, obj|
        file.puts "\n\t#{key}\t\t#{obj[:sum]} seconds\t(#{obj[:count]} times with an average of #{obj[:sum] / obj[:count]} seconds)"

        if tree[:ar_counts][key]
          _, custom_text = formatter.format(tree[:ar_counts][key], "\t\t\t")
          file.puts(text) unless custom_text.empty?
        end

        printed_something = true
      end

      if printed_something
        file.puts
        file.puts "Request took approximately #{time.now.to_f - tree[:request_start_time].to_f} seconds."
        file.close unless file_given
        system("open #{path} -t -g")
      else
        file.close
        File.unlink(path) unless file_given
      end
    end
  end
end

