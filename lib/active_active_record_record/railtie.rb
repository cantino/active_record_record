require 'active_record_record/mixins/action_controller'
require 'active_record_record/mixins/active_record'

module ActiveActiveRecordRecord
  class Railtie < Rails::Railtie
    ActiveSupport.on_load :action_controller do
      ActionController::Base.include ActiveActiveRecordRecord::Mixins::ActionController
    end

    ActiveSupport.on_load :active_record do
      ActiveRecord::Base.include ActiveActiveRecordRecord::Mixins::ActiveRecord
    end

    if ENV['COUNT_OBJECTS'] && Rails.env.development?
      require 'active_record_record/monkey_patcher'
      config.after_initialize do
        MonkeyPatcher.instrument_renders!
        MonkeyPatcher.instrument_query_cache!
        MonkeyPatcher.instrument_mysql_adapter!
        MonkeyPatcher.log_model_instantiation!
        MonkeyPatcher.hook_request_cycle!
      end
    end
  end
end
