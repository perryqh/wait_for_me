module WaitForMe
  class WaitingWorker
    include ::Sidekiq::Worker
    WAITING_WORKER_QUEUE = :wait_for_me

    sidekiq_options retry: 3, queue: WAITING_WORKER_QUEUE, backtrace: true

    def perform(group_key)
      group = Group.find_by(group_key: group_key)
      return if group.nil?

      group.call_execute_after_waiting
      group.destroy if group.all_participants_arrived?
    end
  end
end