FactoryBot.define do
  factory :wait_for_me_group, class: WaitForMe::Group do
    sequence :group_key do |n|
      "group-#{n}"
    end
    execute_after_waiting { 'Foo::CallMe.baz' }
    sequence(:execute_after_waiting_params) do |n|
      ["foo-#{n}"]
    end
    wait_time_in_seconds { 3 }
    expected_number_of_participants { 2 }
  end

  factory :wait_for_me_participant, class: WaitForMe::Participant do
    group { create(:wait_for_me_group) }
    sequence :participant_key do |n|
      "part-#{n}"
    end
  end
end