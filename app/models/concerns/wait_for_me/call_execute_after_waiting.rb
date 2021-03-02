module WaitForMe
  module CallExecuteAfterWaiting
    extend ActiveSupport::Concern

    def call_execute_after_waiting
      execute_after_waiting_class.constantize.send(execute_after_waiting_method,
                                                   *execute_after_waiting_params)
    end

    def execute_after_waiting_method
      execute_after_waiting.split('.').last
    end

    def execute_after_waiting_class
      execute_after_waiting.split('.').first
    end
  end
end