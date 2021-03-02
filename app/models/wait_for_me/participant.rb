module WaitForMe
  class Participant < ApplicationRecord
    belongs_to(:group,
               class_name:  'WaitForMe::Group',
               foreign_key: :group_key,
               primary_key: :group_key)
    validates :participant_key, uniqueness: true
  end
end