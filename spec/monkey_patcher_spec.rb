require 'spec_helper'

describe ActiveRecordRecord::MonkeyPatcher
  context ".instrument_renders!"
    context ActionView::Renderer
      context "#render_with_time_logging"
        it "is aliased to #render and #time_logging"

    context ActiveRecord::ConnectionAdapters::QueryCache
      context "#select_all"
    
  context ".instrument_query_cache!"
    context ActiveRecord::ConnectionAdapters::QueryCache
      context "#select_all"

  context ".instrument_mysql_adapter!"
    context ActiveRecord::ConnectionAdapters::Mysql2Adapter
      context "#execute_with_logging"

  context ".log_model_instantiation!"
    context ActiveRecord::Base
      context "log_initialize"

