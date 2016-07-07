class TextFormatter
  attr_accessor :lines

  def self.format(stats, prefix = '')
    formatter = new(prefix)
    printed_something = formatter.format(stats)
    return printed_something, formatter.lines.join
  end

  def initialize(prefix = '')
    @prefix = prefix
    @lines = []
  end

  def format(stats)
    return false unless stats

    stat_data = deep_copy(stats)

    printed_something = false

    sql_data = stat_data.delete(:sql_data)
    query_cache_data = stat_data.delete(:query_cache_data)
    render_data = stat_data.delete(:render_data)

    stat_data.to_a.sort { |a, b| b.last[:total] <=> a.last[:total] }.each do |klass, counts|
      add_text("#{prefix}#{klass} (#{counts.delete(:total)} loads / #{counts.delete(:ids).uniq.length} unique):")
      counts.to_a.sort { |a, b| b.last <=> a.last }.each do |place, count|
        printed_something = true
        add_text("#{prefix}  #{count}#{" " * ([0, 4 - count.to_s.length].max)}- #{place}")
      end
      add_new_line
    end

    if render_data
      count = render_data.delete(:count)
      add_new_line
      add_text("#{prefix}#{count} Renders")

      render_data.to_a.sort { |a, b| (b.last[:duration]/b.last[:count].to_f) <=> (a.last[:duration]/a.last[:count].to_f) }.each do |place, data|
        add_text("#{prefix}   #{data[:count]}#{" " * ([0, 4 - data[:count].to_s.length].max)}- #{place} (#{data[:duration]}s, average of #{data[:duration] / data[:count].to_f}s per render)")
      end

      add_new_line
      add_new_line
    end

    if sql_data
      count = sql_data.delete(:count)
      duration = sql_data.delete(:duration)
      add_new_line
      add_text("#{prefix}#{count} SQL Queries (totaling #{duration}s with an average of #{duration / count.to_f}s per query)")

      sql_data.to_a.sort { |a, b| b.last[:duration] <=> a.last[:duration] }.each do |place, data|

        add_text("#{prefix}   #{data[:count]}#{" " * ([0, 4 - data[:count].to_s.length].max)}- #{place} (#{data[:duration]}s, average of #{data[:duration] / data[:count].to_f}s per query)")
        prefix2 = "#{prefix}   #{" " * data[:count].to_s.length}#{" " * ([0, 4 - data[:count].to_s.length].max)}"

        data[:queries].to_a.sort { |a, b| b.last[:duration] <=> a.last[:duration] }.each do |query, query_data|
          add_text("#{prefix2}   #{query_data[:count]}#{" " * ([0, 4 - query_data[:count].to_s.length].max)} - #{query} (#{query_data[:duration]}s total)")
        end

        add_new_line
      end

      add_new_line
    end

    if query_cache_data
      count = query_cache_data.delete(:count)
      add_new_line
      add_text("#{prefix}#{count} SQL Cache Queries")

      query_cache_data.to_a.sort { |a, b| b.last[:count] <=> a.last[:count] }.each do |place, data|
        add_text("#{prefix}   #{data[:count]}#{" " * ([0, 4 - data[:count].to_s.length].max)}- #{place}")
        prefix2 = "#{prefix}   #{" " * data[:count].to_s.length}#{" " * ([0, 4 - data[:count].to_s.length].max)}"
        data[:queries].to_a.sort { |a, b| b.last <=> a.last }.each do |query, c|
          add_text("#{prefix2}   #{c}#{" " * ([0, 4 - c.to_s.length].max)} - #{query}")
        end
        add_new_line
      end

      2.times{ add_new_line }
    end

    printed_something
  end

  private

  attr_accessor :prefix

  def add_text(string)
    lines << "#{string}\n"
  end

  def add_new_line
    lines << "\n"
  end

  def deep_copy(hash)
    Marshal.load(Marshal.dump(hash))
  end
end
