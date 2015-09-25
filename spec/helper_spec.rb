require 'spec_helper'

describe ActiveRecordRecord::Helper do
    # let(:caller) do  
    #   [
    #     "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/pry_instance.rb:355:in `eval'",
    #     "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/pry_instance.rb:355:in `evaluate_ruby'",
    #     "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/pry_instance.rb:323:in `handle_line'",
    #     "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/pry_instance.rb:243:in `block (2 levels) in eval'",
    #     "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/pry_instance.rb:242:in `catch'",
    #     "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/pry_instance.rb:242:in `block in eval'",
    #     "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/pry_instance.rb:241:in `catch'",
    #     "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/pry_instance.rb:241:in `eval'",
    #     "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/repl.rb:77:in `block in repl'",
    #     "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/repl.rb:67:in `loop'",
    #     "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/repl.rb:67:in `repl'",
    #     "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/repl.rb:38:in `block in start'",
    #     "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/input_lock.rb:61:in `call'",
    #     "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/input_lock.rb:61:in `__with_ownership'",
    #     "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/input_lock.rb:79:in `with_ownership'",
    #     "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/repl.rb:38:in `start'",
    #     "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/repl.rb:15:in `start'",
    #     "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/pry_class.rb:169:in `start'",
    #     "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/cli.rb:219:in `block in <top (required)>'",
    #     "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/cli.rb:83:in `call'",
    #     "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/cli.rb:83:in `block in parse_options'",
    #     "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/cli.rb:83:in `each'",
    #     "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/lib/pry/cli.rb:83:in `parse_options'",
    #     "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/gems/pry-0.10.1/bin/pry:16:in `<top (required)>'",
    #     "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/bin/pry:23:in `load'",
    #     "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/bin/pry:23:in `<main>'",
    #     "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/bin/ruby_executable_hooks:15:in `eval'",
    #     "/Users/fredflinstone/.rvm/gems/ruby-2.1.5@mavenlink/bin/ruby_executable_hooks:15:in `<main>'"
    #   ]
    # end 
  #
  describe ".track_time_as"
    context "when in a rails developement environment"
      context "and COUNT_OBJECTS is true"
        it "creates thread current hash keyed with :times"
        it "creates thread current hash tracking sum or count"
        context "when sum or count have not yet be set"
            it "they will be defaulted to 0"

    context "when in developement environment"
      context  "and COUNT_OBJECTS is false"

    context "when not in a rails developement environment"
      context "and COUNT_OBJECTS is true"
    context "when not in a rails developement environment"
      context  "and COUNT_OBJECTS is false"

  describe ".use_ar_count_key" 
    context "given a count key"
      it "will use the new count key for the duration of one block only"

  describe ".clean_trace"
    context "given a stack track trace and length"
      it "parses out releavent app code from a stack trace array"

  describe ".clean_queries"
    it "replaces scary numbers with (?)"
    it "replaced extra spaces with a single space"

end

