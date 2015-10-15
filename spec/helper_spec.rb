require 'spec_helper'
require_relative "../lib/active_record_record/helper"

describe ActiveRecordRecord::Helper do
  # Start of temporary hack
  before(:all) do 
    class Rails
      def self.env
        Faker.new
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


  let(:caller) do
    [
      "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/pry_instance.rb:355:in `eval'",
      "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/pry_instance.rb:355:in `evaluate_ruby'",
      "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/pry_instance.rb:323:in `handle_line'",
      "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/pry_instance.rb:243:in `block (2 levels) in eval'",
      "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/pry_instance.rb:242:in `catch'",
      "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/pry_instance.rb:242:in `block in eval'",
      "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/pry_instance.rb:241:in `catch'",
      "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/pry_instance.rb:241:in `eval'",
      "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/repl.rb:77:in `block in repl'",
      "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/repl.rb:67:in `loop'",
      "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/repl.rb:67:in `repl'",
      "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/repl.rb:38:in `block in start'",
      "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/input_lock.rb:61:in `call'",
      "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/input_lock.rb:61:in `__with_ownership'",
      "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/input_lock.rb:79:in `with_ownership'",
      "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/repl.rb:38:in `start'",
      "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/repl.rb:15:in `start'",
      "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/pry_class.rb:169:in `start'",
      "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/cli.rb:219:in `block in <top (required)>'",
      "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/cli.rb:83:in `call'",
      "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/cli.rb:83:in `block in parse_options'",
      "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/cli.rb:83:in `each'",
      "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/cli.rb:83:in `parse_options'",
      "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/bin/pry:16:in `<top (required)>'",
      "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/bin/pry:23:in `load'",
      "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/bin/pry:23:in `<main>'",
      "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/bin/ruby_executable_hooks:15:in `eval'",
      "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/bin/ruby_executable_hooks:15:in `<main>'"
    ]
  end

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

  # describe ".use_ar_count_key"
  #   context "given a count key"
  #     it "will use the new count key for the duration of one block only"

  # describe ".clean_trace"
  #   context "given a stack track trace and length"
  #     it "parses out releavent app code from a stack trace array"

  # describe ".clean_queries"
  #   it "replaces scary numbers with (?)"
  #   it "replaced extra spaces with a single space"
end

