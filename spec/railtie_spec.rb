describe Railtie do
  context "ActiveSupport on_load behaviors" do
    it "adds ActiveRecordRecord to ActionController"
    it "addes TimeTracker::Helper to ActiveSupport"
  end

  context "When user sets 'COUNT_OBJECTS'" do
    it "will require monkey_patcher"
  end
end
