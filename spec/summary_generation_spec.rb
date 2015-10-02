require "spec_helper"
require_relative "../lib/active_record_record/summary_generation"

describe ActiveRecordRecord::SummaryGeneration do
 describe "#clear_ar_counts" do
   class StubClass
     include ActiveRecordRecord::SummaryGeneration
   end

   before do
     Thread.current[:request_start_time] = "00:00:00"
     Thread.current[:ar_counts] = { test: "I love ar_counts" }
     Thread.current[:times] = { times: "Are changing" }
     Thread.current[:do_counts] = false
     Thread.current[:objects_key] = :silly_user_key
     StubClass.new.clear_ar_counts
   end

    it "will reset all thread current variables" do
      expect(Thread.current[:request_start_time]).to_not eq("00:00:00")
      expect(Thread.current[:ar_counts]).to eq({})
      expect(Thread.current[:times]).to eq({})
      expect(Thread.current[:do_counts]).to eq(true)
      expect(Thread.current[:objects_key]).to eq(:default)
    end
  end

  describe "#dump_counts" do
    let(:stat_data) do
      {
        sql_data: {
          count: 6,
          duration: 0.019482135772705078,
            "api/v1/posts_controller.rb:5:in `block in index',"\
            "api/v1/posts_controller.rb:5:in `index',"\
            "application_controller.rb:783:in `handle_read_only_mode',"\
            "application_controller.rb:799:in `handle_intuit_errors',"\
            "application_controller.rb:355:in `set_timezone'" => {
            count: 3,
            duration: 0.011040925979614258,
            queries: {
              "SHOW FULL FIELDS FROM `cats`" => {
                count: 1,
                duration: 0.004291057586669922
              },
              "SHOW TABLES LIKE 'cats'" => {
                count: 1,
                duration: 0.0037250518798828125
              },
              "SHOW CREATE TABLE `cats`" => {
                count: 1,
                duration: 0.0030248165130615234
              }
            }
          },
          "api/v1/cherrio_controller.rb:5:in `index',"\
          "application_controller.rb:666:in `handle_mode',"\
          "application_controller.rb:444:in `handle_errors',"\
          "application_controller.rb:111:in `set_timezone',"\
          "lib/cat_box/cat_locator.rb:22:in `cat_location'" =>
          {
            count: 3,
            duration: 0.00844120979309082,
            queries: {
              "SELECT COUNT(distinct `cherrios`.id) FROM `cherrios`" => {
                count: 1,
                duration: 0.0029501914978027344
              },
              "SELECT `settings`.* FROM `settings` WHERE `settings`.`user_id` = ? AND `settings`.`key` IN ('thing1', 'thing2', 'thing3')"=> {
                count: 1,
                duration: 0.002955198287963867
              },
              "SELECT `cats`.* FROM `cats` WHERE `cats`.`type` IN ('SpaghettiAndMeatballs') AND ?=?" => {
                count: 1,
                duration: 0.0025358200073242188
              }
            }
          }
        }
      }
    end

    it "will format things" do
      path = "/tmp/#{Time.now.to_f}_temp_spec.txt"
      temp_file = File.open(path, "w")
      StubClass.dump_counts(stat_data, temp_file)

      # ---
      # dumped_file = File.read path
      # expect things about dumped_file
      # expect things about dumped_file
      # expect things about dumped_file
      # ---

      temp_file.close
      File.unlink(path) # deletes file?
    end

  end

  describe "#print_ar_counts"
end
