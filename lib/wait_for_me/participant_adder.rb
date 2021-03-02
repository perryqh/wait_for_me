module WaitForMe
  class ParticipantAdder
    REQUIRED_PARAMS = [:participant_key, :group_key, :number_of_participants_in_group,
                       :execute_after_waiting, :wait_time_in_seconds].freeze
    attr_reader *REQUIRED_PARAMS
    attr_reader :execute_after_waiting_params

    def initialize(params)
      params.keys.each do |key|
        instance_variable_set("@#{key}", params[key])
      end
      verify_params!
    end

    def self.add(params)
      new(params).add
    end

    def add
      create_or_update_group
      participant
      group.delete_job

      if group.all_participants_arrived?
        group.call_execute_after_waiting
        group.destroy
      else
        enqueue_worker
      end
    end

    def enqueue_worker
      job_id = WaitingWorker.perform_in(wait_time_in_seconds.seconds,
                                        group.group_key)
      group.update(job_id: job_id)
    end

    def participant
      @participant ||= group.participants.create(participant_key: participant_key)
    end

    def group
      @group ||= Group.where(group_key: group_key).first_or_create
    end

    def create_or_update_group
      group.update(expected_number_of_participants: number_of_participants_in_group,
                              execute_after_waiting:           execute_after_waiting,
                              execute_after_waiting_params:    execute_after_waiting_params,
                              wait_time_in_seconds:            wait_time_in_seconds)
    end

    def verify_params!
      errors = REQUIRED_PARAMS.collect do |p|
        "#{p} is required" if send(p).blank?
      end.compact
      raise ArgumentError.new(errors.join(', ')) if errors.length > 0
    end
  end
end