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
      context "and when Rails ENV is false"
        it "will silently exit"

    context "when COUNT_OBJECTS is false"
        it "will silently exit"
      context "and when Rails ENV is true"
        it "will silently exit"
      context "and when Rails ENV is false"
        it "will silently exit"
  end
end
