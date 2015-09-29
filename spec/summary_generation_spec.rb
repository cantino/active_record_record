require 'spec_helper'

define ActiveRecordRecord::SummaryGeneration do
  define "#clear_ar_counts" do
    before do
      Thread.current[:ar_counts] = { test: "I love ar_counts" }
      Thread.current[:times] = { times: "Are changing" }
      Thread.current[:request_start_time] = "This is the start time, trust me"
      Thread.current[:do_counts] = false
      Thread.current[:objects_key] = :silly_user_key
    end

    it "will reset all thread current variables" do
      expect(Thread.current[:ar_counts]).to eq({})
      expect(Thread.current[:times]).to eq({})
      # We should use time cop
      # expect(Thread.current[:request_start_time]).to eq(Time.now)
      expect(Thread.current[:do_counts]).to eq(true)
      expect(Thread.current[:objects_key]).to eq(:default)
    end
  end

  define "#dump_counts"
  define "#print_ar_counts"
end
