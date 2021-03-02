require 'rails_helper'

RSpec.describe WaitForMe::Group do
  it { is_expected.to have_many :participants }
  it { is_expected.to validate_presence_of :execute_after_waiting }
  it { is_expected.to validate_presence_of :expected_number_of_participants }
  it { is_expected.to validate_presence_of :wait_time_in_seconds }

  describe 'uniqueness' do
    let!(:group) { create(:wait_for_me_group) }
    subject { described_class.new(group_key: group.group_key) }

    it 'is invalid' do
      expect(subject).to_not be_valid
      expect(subject.errors[:group_key]).to eq(['has already been taken'])
    end
  end
end