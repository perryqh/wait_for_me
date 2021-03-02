module WaitForMe
  class Group < ApplicationRecord
    include CallExecuteAfterWaiting, DeleteJob

    has_many(:participants,
             class_name:  'WaitForMe::Participant',
             foreign_key: :group_key,
             primary_key: :group_key,
             dependent: :destroy)

    validates :group_key, uniqueness: true
    validates :execute_after_waiting, presence: true
    validates :expected_number_of_participants, presence: true
    validates :wait_time_in_seconds, presence: true

    def all_participants_arrived?
      participants.count >= expected_number_of_participants
    end
  end
end