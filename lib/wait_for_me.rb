require "wait_for_me/engine"
require "wait_for_me/participant_adder"
require "wait_for_me/wait_remover"
require 'sidekiq'
require 'sidekiq/api'

module WaitForMe
  def self.add_participant(participant_key: nil,
                           group_key: nil,
                           number_of_participants_in_group: nil,
                           execute_after_waiting: nil,
                           execute_after_waiting_params: [],
                           wait_time_in_seconds: nil)
    ParticipantAdder.add(participant_key:                 participant_key,
                         group_key:                       group_key,
                         number_of_participants_in_group: number_of_participants_in_group,
                         execute_after_waiting:           execute_after_waiting,
                         execute_after_waiting_params:    execute_after_waiting_params,
                         wait_time_in_seconds:            wait_time_in_seconds)
  end

  # removes the group and deletes the associated scheduled sidekiq job if they exist
  def self.remove_wait(group_key)
    WaitRemover.remove_wait(group_key)
  end
end