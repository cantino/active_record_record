module ActiveRecordRecord
  module Helper
    def self.track_time_as(key, options = {})
      if ENV['COUNT_OBJECTS'] && Rails.env.development?
        use_ar_count_key(key) do
          start = Time.now.to_f
          yield.tap do
            Thread.current[:times] ||= {}
            Thread.current[:times][key] ||= {}
            Thread.current[:times][key][:count] ||= 0
            Thread.current[:times][key][:sum] ||= 0
            Thread.current[:times][key][:count] += 1
            Thread.current[:times][key][:sum] += Time.now.to_f - start
          end
        end
      else
        yield
      end
    end

    def self.use_ar_count_key(key)
      old_key = Thread.current[:objects_key]
      Thread.current[:objects_key] = key || old_key
      yield
    ensure
      Thread.current[:objects_key] = old_key
    end

    def self.clean_trace(stack, length = 4)
      escaped_rails_root = Regexp.escape(Rails.root.to_s)
      cleaned_trace = stack.find_all { |i| i =~ /#{escaped_rails_root}\/(lib|app)/ }.reject { |i| i =~ /railtie\.rb/ }.map do |line|
        line.gsub(/^#{escaped_rails_root}\//, '').gsub(/^app\/(views|models|controllers)?\/?/, '').gsub(/:in\s+._app_views_.*/, '')
      end
      cleaned_trace[0..length].join(', ') || 'unknown'
    end

    def self.clean_queries(query)
      query.gsub(/\(\s*(\d+\s*,)*?\d+\s*\)/, '(?)').gsub(/\d+/, '?').gsub(/\s+/, ' ')
    end
  end
end
