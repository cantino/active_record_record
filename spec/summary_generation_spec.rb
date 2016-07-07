require 'spec_helper'
require_relative '../lib/active_record_record/summary_generation'
require_relative 'support/example_data'

describe ActiveRecordRecord::SummaryGeneration do
  include ExampleData

  before(:all) do
    class StubController
      attr_accessor :controller_name, :action_name, :request
      include ActiveRecordRecord::SummaryGeneration
    end

    class StubFile
      attr_accessor :file_contents

      def initialize
        @file_contents = []
      end

      def puts(content = '')
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

  describe '#clear_ar_counts' do
    before do
      Thread.current[:request_start_time] = '00:00:00'
      Thread.current[:ar_counts] = { test: 'I love ar_counts'}
      Thread.current[:times] = { times: 'Are changing'}
      Thread.current[:do_counts] = false
      Thread.current[:objects_key] = :silly_user_key
      stub_controller.clear_ar_counts
    end

    after do
      Thread.current[:request_start_time] = nil
      Thread.current[:ar_counts] = nil
      Thread.current[:times] = nil
      Thread.current[:do_counts] = nil
      Thread.current[:objects_key] = nil
    end

    it 'will reset all thread current variables' do
      expect(Thread.current[:request_start_time]).to_not eq('00:00:00')
      expect(Thread.current[:ar_counts]).to eq({})
      expect(Thread.current[:times]).to eq({})
      expect(Thread.current[:do_counts]).to eq(true)
      expect(Thread.current[:objects_key]).to eq(:default)
    end
  end


  describe '#print_ar_counts' do
    before do
      ActiveRecordRecord.skip_path_regex = /skip/
      stub_controller.request = Struct.new(:original_url).new(original_url)
    end

    context 'when the request url is allowed' do
      let(:original_url) { 'some_allowed_url' }
      let(:stub_file) { StubFile.new }
      let(:stat_data) { ExampleData::AR_COUNT }
      let(:time_stub) { double("Timer", now: 100 ) }
      let(:expected_formatted_data) { ExampleData::ExpectedFinalPrint }
      let(:options) do
        {
          tree: stat_data,
          file: stub_file,
          time_class: time_stub,
          open_file: false,
        }
      end

      it 'will produce a complete report' do
        stub_controller.print_ar_counts(options)
        expect(stub_file.file_contents).to match_array(expected_formatted_data)
      end
    end

    context 'when the request url is not allowed' do
      let(:original_url) { 'something_to_skip' }

      it 'will return nil' do
        expect(stub_controller.print_ar_counts).to be_nil
      end
    end
  end
end
