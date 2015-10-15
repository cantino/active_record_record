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
        "/Users/fredflinstone/"
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
      ["/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/byebug-4.0.5/lib/byebug/command.rb:56:in `eval'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/byebug-4.0.5/lib/byebug/command.rb:56:in `bb_warning_eval'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/byebug-4.0.5/lib/byebug/commands/eval.rb:45:in `block in eval_with_setting'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/byebug-4.0.5/lib/byebug/commands/eval.rb:20:in `allowing_other_threads'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/byebug-4.0.5/lib/byebug/commands/eval.rb:41:in `eval_with_setting'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/byebug-4.0.5/lib/byebug/commands/eval.rb:71:in `block in execute'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/byebug-4.0.5/lib/byebug/commands/eval.rb:30:in `run_with_binding'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/byebug-4.0.5/lib/byebug/commands/eval.rb:70:in `execute'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/byebug-4.0.5/lib/byebug/processors/command_processor.rb:125:in `one_unknown_cmd'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/byebug-4.0.5/lib/byebug/processors/command_processor.rb:135:in `one_cmd'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/byebug-4.0.5/lib/byebug/processors/command_processor.rb:111:in `repl'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/byebug-4.0.5/lib/byebug/processors/command_processor.rb:94:in `process_commands'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/byebug-4.0.5/lib/byebug/processors/command_processor.rb:47:in `at_line'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/byebug-4.0.5/lib/byebug/context.rb:90:in `at_line'",
      "/Users/gregmcguirk/workspace/mavenlink/app/controllers/workspaces_controller.rb:46:in `show'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/actionpack-4.1.13/lib/action_controller/metal/implicit_render.rb:4:in `send_action'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/actionpack-4.1.13/lib/abstract_controller/base.rb:189:in `process_action'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/actionpack-4.1.13/lib/action_controller/metal/rendering.rb:10:in `process_action'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/actionpack-4.1.13/lib/abstract_controller/callbacks.rb:20:in `block in process_action'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:113:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:113:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:552:in `block (2 levels) in compile'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:502:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:502:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:495:in `block (2 levels) in around'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:306:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:306:in `block (2 levels) in halting'",
      "/Users/gregmcguirk/workspace/mavenlink/app/controllers/application_controller.rb:791:in `handle_read_only_mode'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:429:in `block in make_lambda'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:305:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:305:in `block in halting'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:494:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:494:in `block in around'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:502:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:502:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:495:in `block (2 levels) in around'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:306:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:306:in `block (2 levels) in halting'",
      "/Users/gregmcguirk/workspace/mavenlink/app/controllers/application_controller.rb:807:in `handle_intuit_errors'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:429:in `block in make_lambda'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:305:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:305:in `block in halting'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:494:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:494:in `block in around'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:502:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:502:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:495:in `block (2 levels) in around'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:306:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:306:in `block (2 levels) in halting'",
      "/Users/gregmcguirk/workspace/mavenlink/app/controllers/application_controller.rb:363:in `set_timezone'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:429:in `block in make_lambda'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:305:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:305:in `block in halting'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:494:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:494:in `block in around'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:502:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:502:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:495:in `block (2 levels) in around'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:306:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:306:in `block (2 levels) in halting'",
      "/Users/gregmcguirk/workspace/mavenlink/lib/mavenlink_extensions/store_location.rb:22:in `store_location'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:429:in `block in make_lambda'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:305:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:305:in `block in halting'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:494:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:494:in `block in around'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:502:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:502:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:495:in `block (2 levels) in around'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:306:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:306:in `block (2 levels) in halting'",
      "/Users/gregmcguirk/workspace/mavenlink/app/controllers/application_controller.rb:840:in `set_default_mailer_url_options'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:429:in `block in make_lambda'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:305:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:305:in `block in halting'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:494:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:494:in `block in around'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:502:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:502:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:495:in `block (2 levels) in around'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:306:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:306:in `block (2 levels) in halting'",
      "/Users/gregmcguirk/workspace/mavenlink/app/controllers/application_controller.rb:863:in `current_user_assignment'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:429:in `block in make_lambda'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:305:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:305:in `block in halting'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:494:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:494:in `block in around'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:502:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:502:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:86:in `run_callbacks'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/actionpack-4.1.13/lib/abstract_controller/callbacks.rb:19:in `process_action'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/actionpack-4.1.13/lib/action_controller/metal/rescue.rb:29:in `process_action'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/actionpack-4.1.13/lib/action_controller/metal/instrumentation.rb:32:in `block in process_action'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/notifications.rb:159:in `block in instrument'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/notifications/instrumenter.rb:20:in `instrument'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/notifications.rb:159:in `instrument'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/actionpack-4.1.13/lib/action_controller/metal/instrumentation.rb:30:in `process_action'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/actionpack-4.1.13/lib/action_controller/metal/params_wrapper.rb:250:in `process_action'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activerecord-4.1.13/lib/active_record/railties/controller_runtime.rb:18:in `process_action'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/actionpack-4.1.13/lib/abstract_controller/base.rb:136:in `process'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/actionview-4.1.13/lib/action_view/rendering.rb:30:in `process'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/actionpack-4.1.13/lib/action_controller/metal.rb:196:in `dispatch'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/actionpack-4.1.13/lib/action_controller/metal/rack_delegation.rb:13:in `dispatch'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/actionpack-4.1.13/lib/action_controller/metal.rb:232:in `block in action'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/actionpack-4.1.13/lib/action_dispatch/routing/route_set.rb:82:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/actionpack-4.1.13/lib/action_dispatch/routing/route_set.rb:82:in `dispatch'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/actionpack-4.1.13/lib/action_dispatch/routing/route_set.rb:50:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/actionpack-4.1.13/lib/action_dispatch/journey/router.rb:73:in `block in call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/actionpack-4.1.13/lib/action_dispatch/journey/router.rb:59:in `each'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/actionpack-4.1.13/lib/action_dispatch/journey/router.rb:59:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/actionpack-4.1.13/lib/action_dispatch/routing/route_set.rb:692:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/rack-mobile-detect-0.4.0/lib/rack/mobile-detect.rb:164:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/rack-attack-4.2.0/lib/rack/attack.rb:104:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/rack-1.5.5/lib/rack/etag.rb:23:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/rack-1.5.5/lib/rack/conditionalget.rb:25:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/rack-1.5.5/lib/rack/head.rb:11:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/actionpack-4.1.13/lib/action_dispatch/middleware/params_parser.rb:27:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/actionpack-4.1.13/lib/action_dispatch/middleware/flash.rb:254:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/rack-1.5.5/lib/rack/session/abstract/id.rb:225:in `context'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/rack-1.5.5/lib/rack/session/abstract/id.rb:220:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/actionpack-4.1.13/lib/action_dispatch/middleware/cookies.rb:562:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activerecord-4.1.13/lib/active_record/query_cache.rb:36:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activerecord-4.1.13/lib/active_record/connection_adapters/abstract/connection_pool.rb:621:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activerecord-4.1.13/lib/active_record/migration.rb:380:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/actionpack-4.1.13/lib/action_dispatch/middleware/callbacks.rb:29:in `block in call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/callbacks.rb:82:in `run_callbacks'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/actionpack-4.1.13/lib/action_dispatch/middleware/callbacks.rb:27:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/actionpack-4.1.13/lib/action_dispatch/middleware/reloader.rb:73:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/actionpack-4.1.13/lib/action_dispatch/middleware/remote_ip.rb:76:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/airbrake-4.3.0/lib/airbrake/rails/middleware.rb:13:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/better_errors-1.1.0/lib/better_errors/middleware.rb:84:in `protected_app_call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/better_errors-1.1.0/lib/better_errors/middleware.rb:79:in `better_errors_call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/better_errors-1.1.0/lib/better_errors/middleware.rb:56:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/actionpack-4.1.13/lib/action_dispatch/middleware/debug_exceptions.rb:17:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/actionpack-4.1.13/lib/action_dispatch/middleware/show_exceptions.rb:30:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/railties-4.1.13/lib/rails/rack/logger.rb:38:in `call_app'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/railties-4.1.13/lib/rails/rack/logger.rb:20:in `block in call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/tagged_logging.rb:68:in `block in tagged'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/tagged_logging.rb:26:in `tagged'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/tagged_logging.rb:68:in `tagged'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/railties-4.1.13/lib/rails/rack/logger.rb:20:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/actionpack-4.1.13/lib/action_dispatch/middleware/request_id.rb:21:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/rack-1.5.5/lib/rack/methodoverride.rb:21:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/rack-1.5.5/lib/rack/runtime.rb:17:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/activesupport-4.1.13/lib/active_support/cache/strategy/local_cache_middleware.rb:26:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/rack-1.5.5/lib/rack/lock.rb:17:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/actionpack-4.1.13/lib/action_dispatch/middleware/static.rb:84:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/rack-1.5.5/lib/rack/sendfile.rb:112:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/actionpack-4.1.13/lib/action_dispatch/middleware/ssl.rb:24:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/rack-utf8_sanitizer-1.3.0/lib/rack/utf8_sanitizer.rb:15:in `call'",
      "/Users/gregmcguirk/workspace/mavenlink/app/middleware/handle_bad_percent_encoding_app.rb:12:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/airbrake-4.3.0/lib/airbrake/user_informer.rb:16:in `_call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/airbrake-4.3.0/lib/airbrake/user_informer.rb:12:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/railties-4.1.13/lib/rails/engine.rb:514:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/railties-4.1.13/lib/rails/application.rb:144:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/rack-1.5.5/lib/rack/lint.rb:49:in `_call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/rack-1.5.5/lib/rack/lint.rb:37:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/rack-1.5.5/lib/rack/showexceptions.rb:24:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/rack-1.5.5/lib/rack/commonlogger.rb:33:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/sinatra-1.4.6/lib/sinatra/base.rb:218:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/rack-1.5.5/lib/rack/chunked.rb:43:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/rack-1.5.5/lib/rack/content_length.rb:14:in `call'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/unicorn-4.8.3/lib/unicorn/http_server.rb:576:in `process_client'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/unicorn-4.8.3/lib/unicorn/http_server.rb:670:in `worker_loop'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/unicorn-4.8.3/lib/unicorn/http_server.rb:525:in `spawn_missing_workers'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/unicorn-4.8.3/lib/unicorn/http_server.rb:140:in `start'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/gems/unicorn-4.8.3/bin/unicorn:126:in `<top (required)>'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/bin/unicorn:23:in `load'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/bin/unicorn:23:in `<main>'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/bin/ruby_executable_hooks:15:in `eval'",
      "/Users/gregmcguirk/.rvm/gems/ruby-2.2.2@mavenlink/bin/ruby_executable_hooks:15:in `<main>'"]
    end

    context "given a stack track trace" do
      it "parses out releavent app code from a stack trace array" do
      end
    end

  # describe ".clean_queries"
  #   it "replaces scary numbers with (?)"
  #   it "replaced extra spaces with a single space"
end

