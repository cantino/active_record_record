require "spec_helper"
require_relative "../lib/active_record_record/summary_generation"
require_relative "support/example_data"

describe ActiveRecordRecord::SummaryGeneration do
  include ExampleData

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

  let(:stub_controller) { StubController.new }

  describe "#clear_ar_counts" do
    before do
      Thread.current[:request_start_time] = "00:00:00"
      Thread.current[:ar_counts] = { test: "I love ar_counts" }
      Thread.current[:times] = { times: "Are changing" }
      Thread.current[:do_counts] = false
      Thread.current[:objects_key] = :silly_user_key
      stub_controller.new.clear_ar_counts
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
      let(:stub_file) { StubFile.new }
      let(:stat_data) { ExampleData::AR_COUNT }
      let(:time_stub) { double("Timer", now: 100 ) }
      let(:expected_formatted_data) { ExampleData::ExpectedFinalPrint }

      it "will produce a complete report" do
        output = stub_controller.print_ar_counts(tree: stat_data, file: stub_file, time_class: time_stub)
        expect(output).to be_truthy
        expect(stub_file.file_contents).to match_array(expected_formatted_data)
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
