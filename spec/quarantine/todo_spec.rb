require 'spec_helper'
require 'ar_counter'

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

