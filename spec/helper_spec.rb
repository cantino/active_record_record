require 'spec_helper'
require_relative "../lib/active_record_record/helper"

describe ActiveRecordRecord::Helper do

  # Start of temporary hack
  before(:all) do
    class Rails
      def self.env
        Faker.new
      end

      def self.root
        "/Users/dude/workspace/place"
      end
    end

    class Faker
      def development?
        true
      end
    end
  end

  after(:all) do
    Object.send(:remove_const, :Rails)
    Object.send(:remove_const, :Faker)
  end
  # end of temporary hack

  describe ".track_time_as" do
    context "when in a rails developement environment" do
      before { expect(Rails.env.development?).to be_truthy }

      context "and COUNT_OBJECTS is true" do
        before do
          ENV['COUNT_OBJECTS'] = "true"
          Thread.current[:times] = {}
        end

        it "creates thread current hash keyed with :times and a given input key" do
          ActiveRecordRecord::Helper.track_time_as(:spaghetti) { :meatball }

          expect(Thread.current[:times][:spaghetti]).to be_truthy
          expect(Thread.current[:times][:spaghetti][:count]).to eq(1)
          expect(Thread.current[:times][:spaghetti][:sum]).to be_truthy
        end
      end
      context  "and COUNT_OBJECTS is false" do
        before do
          ENV['COUNT_OBJECTS'] = nil
          Thread.current[:times] = {}
        end

        it "will just yield the passed block" do
          ActiveRecordRecord::Helper.track_time_as(:salad) { :rabbit_food }
          expect(Thread.current[:times].has_key?(:salad)).to be_falsy
        end
      end
    end

    context "when not in a Rails developement environment" do
      before do
        allow_any_instance_of(Faker).to receive(:development?).and_return(false)
        Thread.current[:times] = {}
      end

      context "and COUNT_OBJECTS is true" do
        before { ENV['COUNT_OBJECTS'] = "true" }

        it "will just yield the passed block" do
          ActiveRecordRecord::Helper.track_time_as(:hot_chocolate) { :gross }
          expect(Thread.current[:times].has_key?(:hot_chocolate)).to be_falsy
        end
      end

      context "and COUNT_OBJECTS is false" do
        before { ENV['COUNT_OBJECTS'] = nil }

        it "will just yield the passed block" do
          ActiveRecordRecord::Helper.track_time_as(:hot_dogs) { :delicious }
          expect(Thread.current[:times].has_key?(:hot_dogs)).to be_falsy
        end
      end
    end
  end

  describe ".use_ar_count_key" do
    context "given a count key" do
      it "will use the new count key for the duration of one block only" do
        ActiveRecordRecord::Helper.use_ar_count_key(:spitball) do
          expect(Thread.current[:objects_key]).to eq(:spitball)
        end
      end
    end
  end

  describe ".clean_trace"
  let(:caller) do
    # targets are indented more
    [
      "/Users/dude/.rvm/gems/ruby-2.2.2@place/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:502:in `call'",
      "/Users/dude/.rvm/gems/ruby-2.2.2@place/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:306:in `block (2 levels) in halting'",
      "/Users/dude/workspace/place/app/controllers/application_controller.rb:791:in `handle_read_only_mode'",
      "/Users/dude/.rvm/gems/ruby-2.2.2@place/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:429:in `block in make_lambda'",
      "/Users/dude/.rvm/gems/ruby-2.2.2@place/gems/activesupport-4.1.13/railtie.rb:495:in `block (2 levels) in around'",
      "/Users/dude/workspace/place/app/controllers/railtie.rb:791:in `handle_read_only_mode'",
      "/Users/dude/.rvm/gems/ruby-2.2.2@place/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:306:in `call'",
      "/Users/dude/.rvm/gems/ruby-2.2.2@place/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:306:in `block (2 levels) in halting'",
      "/Users/dude/workspace/place/app/views/application_controller.rb:807:in `handle_stuff_errors'",
      "/Users/dude/.rvm/gems/ruby-2.2.2@place/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:305:in `block in halting'",
      "/Users/dude/.rvm/gems/ruby-2.2.2@place/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:494:in `call'",
      "/Users/dude/.rvm/gems/ruby-2.2.2@place/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:494:in `block in around'",
      "/Users/dude/.rvm/gems/ruby-2.2.2@place/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:306:in `block (2 levels) in halting'",
      "/Users/dude/workspace/place/app/controllers/application_controller.rb:363:in `set_timezone'",
      "/Users/dude/.rvm/gems/ruby-2.2.2@place/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:429:in `block in make_lambda'",
      "/Users/dude/.rvm/gems/ruby-2.2.2@place/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:502:in `call'",
      "/Users/dude/.rvm/gems/ruby-2.2.2@place/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:306:in `block (2 levels) in halting'",
      "/Users/dude/workspace/place/lib/place_extensions/store_location.rb:22:in `store_location'",
      "/Users/dude/.rvm/gems/ruby-2.2.2@place/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:305:in `call'",
      "/Users/dude/workspace/place/app/models/application_controller.rb:840:in `set_default_mailer_url_options'",
      "/Users/dude/.rvm/gems/ruby-2.2.2@place/bin/ruby_executable_hooks:15:in `<main>'",
    ]
  end

  context "given a stack track trace" do
    it "parses out releavent app code from a stack trace array" do
      trace = ActiveRecordRecord::Helper.clean_trace(caller)
      expect(trace).to eq(
        "application_controller.rb:791:in `handle_read_only_mode',"\
        " application_controller.rb:807:in `handle_stuff_errors',"\
        " application_controller.rb:363:in `set_timezone',"\
        " lib/place_extensions/store_location.rb:22:in `store_location',"\
        " application_controller.rb:840:in `set_default_mailer_url_options'")
    end
  end

  describe ".clean_queries" do
    let(:query) do
      <<-SQL
        User Load (1.3ms)        SELECT `users`.* FROM `users`  WHERE `users`.`id` IN (4, 5, 6, 7, 8, 9, 10, 11, 12, 13)
      SQL
    end

    def self.clean_queries(query)
      query.gsub(/\(\s*(\d+\s*,)*?\d+\s*\)/, '(?)').gsub(/\d+/, '?').gsub(/\s+/, ' ')
    end

    context "replaces scary numbers with (?)" do
      context "replaced extra spaces with a single space" do
        it "and fixes this situation '( 3232323  , empty things 23223 )'" do 
          cleaned_query = ActiveRecordRecord::Helper.clean_queries(query)
          expected_query = " User Load (?.?ms) SELECT `users`.* FROM `users` WHERE `users`.`id` IN (?, ?, ?, ?, ?, ?, ?, ?, ?, ?) "
          expect(cleaned_query).to eq(expected_query)
        end
      end
    end
  end
end

