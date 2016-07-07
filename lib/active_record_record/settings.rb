module ActiveRecordRecord
  def self.skip_path_regex=(value)
    @skip_path_regex = value
  end

  def self.skip_path_regex
    @skip_path_regex
  end
end
