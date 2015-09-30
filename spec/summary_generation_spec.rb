require "spec_helper"
require_relative "../lib/active_record_record/summary_generation"

describe ActiveRecordRecord::SummaryGeneration do
 describe "#clear_ar_counts" do
    before do
      Thread.current[:request_start_time] = "00:00:00"
      Thread.current[:ar_counts] = { test: "I love ar_counts" }
      Thread.current[:times] = { times: "Are changing" }
      Thread.current[:do_counts] = false
      Thread.current[:objects_key] = :silly_user_key

      class StubClass
        include ActiveRecordRecord::SummaryGeneration
      end
      StubClass.new.clear_ar_counts
    end

    it "will reset all thread current variables" do
      expect(Thread.current[:request_start_time]).to_not eq("00:00:00")
      expect(Thread.current[:ar_counts]).to eq({})
      expect(Thread.current[:times]).to eq({})
      expect(Thread.current[:do_counts]).to eq(true)
      expect(Thread.current[:objects_key]).to eq(:default)
    end
  end

  describe "#dump_counts"
  describe "#print_ar_counts"
end
