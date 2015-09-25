require 'spec_helper'
require 'ar_counter'

describe TimeTracker do
  context ".clean_trace" do 
    let(:caller) do  
      [
        "/Users/gregmcguirk/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/pry_instance.rb:355:in `eval'",
        "/Users/gregmcguirk/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/pry_instance.rb:355:in `evaluate_ruby'",
        "/Users/gregmcguirk/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/pry_instance.rb:323:in `handle_line'",
        "/Users/gregmcguirk/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/pry_instance.rb:243:in `block (2 levels) in eval'",
        "/Users/gregmcguirk/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/pry_instance.rb:242:in `catch'",
        "/Users/gregmcguirk/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/pry_instance.rb:242:in `block in eval'",
        "/Users/gregmcguirk/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/pry_instance.rb:241:in `catch'",
        "/Users/gregmcguirk/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/pry_instance.rb:241:in `eval'",
        "/Users/gregmcguirk/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/repl.rb:77:in `block in repl'",
        "/Users/gregmcguirk/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/repl.rb:67:in `loop'",
        "/Users/gregmcguirk/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/repl.rb:67:in `repl'",
        "/Users/gregmcguirk/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/repl.rb:38:in `block in start'",
        "/Users/gregmcguirk/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/input_lock.rb:61:in `call'",
        "/Users/gregmcguirk/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/input_lock.rb:61:in `__with_ownership'",
        "/Users/gregmcguirk/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/input_lock.rb:79:in `with_ownership'",
        "/Users/gregmcguirk/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/repl.rb:38:in `start'",
        "/Users/gregmcguirk/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/repl.rb:15:in `start'",
        "/Users/gregmcguirk/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/pry_class.rb:169:in `start'",
        "/Users/gregmcguirk/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/cli.rb:219:in `block in <top (required)>'",
        "/Users/gregmcguirk/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/cli.rb:83:in `call'",
        "/Users/gregmcguirk/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/cli.rb:83:in `block in parse_options'",
        "/Users/gregmcguirk/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/cli.rb:83:in `each'",
        "/Users/gregmcguirk/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/cli.rb:83:in `parse_options'",
        "/Users/gregmcguirk/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/bin/pry:16:in `<top (required)>'",
        "/Users/gregmcguirk/.rvm/gems/ruby-2.1.5@mavenlink/bin/pry:23:in `load'",
        "/Users/gregmcguirk/.rvm/gems/ruby-2.1.5@mavenlink/bin/pry:23:in `<main>'",
        "/Users/gregmcguirk/.rvm/gems/ruby-2.1.5@mavenlink/bin/ruby_executable_hooks:15:in `eval'",
        "/Users/gregmcguirk/.rvm/gems/ruby-2.1.5@mavenlink/bin/ruby_executable_hooks:15:in `<main>'"
      ]
    end 

    it "parses out releavent app code from a stack trace array" do 
      TimeTracker.clean_trace(call_stack).should eq("win")
    end
  end

  context ".clean_queries"
  it "replaces scary numbers with (?)"
end

describe TimeTracker::MethodWrapping do
  context "#track_method_time" do
    context "when COUNT_OBJECTS is true"
      context "and when Rails ENV is true"
        context "when the user has requested :all" do
          it "will wrap all the methods defind in within this block"\
              "by creating an aliased method appended with _with_ar_tracking"\
              "then wrapping that new alias with TimeTracker::Helper::track_time_as"
        end
      context "and  when Rails ENV is false"
        it "will silently exit"

    context "when COUNT_OBJECTS is false"
        it "will silently exit"
      context "and when Rails ENV is true"
        it "will silently exit"
      context "and when Rails ENV is false"
        it "will silently exit"
  end
end

# describe ArCounterRailtie do 
#   context "ActiveSupport on_load behaviors" do
#     it "addes TimeTracker::Helper to ActionController"
#     it "addes TimeTracker::Helper to ActiveSupport"
#   end

#   context "When user sets 'PROFILE_REQUESTS'" do
#     context "and we are in a rails development environment"
#     context "#start_profiler"
#     context "#stop_profiler"
#   end

#   context "When user sets 'COUNT_OBJECTS'" do
#     context ActionView::Renderer
#       context "#render_with_time_logging"
#         it "is aliased to #render and #time_logging"

#     context ActiveRecord::ConnectionAdapters::QueryCache
#       context "#select_all"

#     context ActiveRecord::ConnectionAdapters::Mysql2Adapter
#       context "#execute_with_logging"

#     context ActiveRecord::Base
#       context "log_initialize"

#     context ActiveController::Base
#       context "#clear_ar_counts"
#       context "#dump_counts"
#       context "#print_ar_counts"
#   end
# end

