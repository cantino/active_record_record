require "spec_helper"
require_relative "../lib/active_record_record/summary_generation"

describe ActiveRecordRecord::SummaryGeneration do

  before(:all) do
    class StubController
      attr_accessor :controller_name, :action_name
      include ActiveRecordRecord::SummaryGeneration
    end

    class StubFile
      attr_accessor :file_contents

      def initialize
        @file_contents = []
      end

      def puts(content = "\n")
        @file_contents << content + "\n"
      end

      def sync=(drop)
        #noop
      end
    end
  end

  after(:all) do
    Object.send(:remove_const, :StubController)
    Object.send(:remove_const, :StubFile)
  end

  describe "#clear_ar_counts" do
    before do
      Thread.current[:request_start_time] = "00:00:00"
      Thread.current[:ar_counts] = { test: "I love ar_counts" }
      Thread.current[:times] = { times: "Are changing" }
      Thread.current[:do_counts] = false
      Thread.current[:objects_key] = :silly_user_key
      StubController.new.clear_ar_counts
    end

    after do
      Thread.current[:request_start_time] = nil
      Thread.current[:ar_counts] = nil
      Thread.current[:times] = nil
      Thread.current[:do_counts] = nil
      Thread.current[:objects_key] = nil
    end

    it "will reset all thread current variables" do
      expect(Thread.current[:request_start_time]).to_not eq("00:00:00")
      expect(Thread.current[:ar_counts]).to eq({})
      expect(Thread.current[:times]).to eq({})
      expect(Thread.current[:do_counts]).to eq(true)
      expect(Thread.current[:objects_key]).to eq(:default)
    end
  end


  describe "#print_ar_counts" do

    context "when printing something" do
      let(:stub_controller) { StubController.new }
      let(:stub_file)  { StubFile.new }

      before do
      end

      it "will add a Timings section" do
      end
    end

    context "when aborting the print action" do
      let(:stub_controller) { StubController.new }
      before do
        stub_controller.controller_name = "page_not_found"
        expect(stub_controller.controller_name).to eq("page_not_found")
      end
    end
  end
end
