require 'rails_helper'

RSpec.describe WaitForMe do
  describe '#add_participant' do
    let(:params) do
      { participant_key:                 'participant_key',
        group_key:                       'group_key',
        number_of_participants_in_group: 1,
        execute_after_waiting:           'execute_after_waiting',
        execute_after_waiting_params:    ['execute_after_waiting_params'],
        wait_time_in_seconds:            33 }
    end

    before do
      allow(WaitForMe::ParticipantAdder).to receive(:add)
    end

    it 'delegates to WaitForMe::ParticipantAdder' do
      described_class.add_participant(params)
      expect(WaitForMe::ParticipantAdder).to have_received(:add).with(params)
    end
  end

  describe '#remove_wait' do
    let(:group_key) { 'group-23' }
    let(:returned) { 'yay!' }
    before do
      allow(WaitForMe::WaitRemover).to receive(:remove_wait).and_return(returned)
    end

    it 'delegates to WaitRemover' do
      expect(described_class.remove_wait(group_key)).to eq(returned)
      expect(WaitForMe::WaitRemover).to have_received(:remove_wait).with(group_key)
    end
  end
end