require 'rails_helper'

RSpec.describe WaitForMe::Participant do
  it { is_expected.to belong_to :group }

  describe 'uniqueness' do
    let!(:participant) { create(:wait_for_me_participant) }
    subject { described_class.new(participant_key: participant.participant_key) }

    it 'is invalid' do
      expect(subject).to_not be_valid
      expect(subject.errors[:participant_key]).to eq(['has already been taken'])
    end
  end
end