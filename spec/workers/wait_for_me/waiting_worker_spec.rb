require 'rails_helper'

RSpec.describe WaitForMe::WaitingWorker do
  it { is_expected.to be_processed_in :wait_for_me }
  it { is_expected.to save_backtrace }
  it { is_expected.to be_retryable(3) }

  describe '#perform' do
    let(:participant) { create(:wait_for_me_participant) }
    let!(:group) { participant.group }
    let(:group_key) { group.group_key }
    subject(:perform) { described_class.new.perform(group_key) }

    context 'when group no longer exists' do
      let(:group_key) { 'lalala' }
      it 'does not blow up' do
        perform
      end
    end

    it 'calls method' do
      perform
      expect(Foo::CallMe.arg1).to eq(group.execute_after_waiting_params.first)
    end

    it 'does not delete group as all participants have not arrived' do
      expect { perform }.to_not change { WaitForMe::Group.count }
      expect(group.reload).to be_present
    end

    context 'when all participants have arrived' do
      before do
        group.participants.create(participant_key: 'all-aboard')
      end

      it 'calls method' do
        perform
        expect(Foo::CallMe.arg1).to eq(group.execute_after_waiting_params.first)
      end

      it 'deletes the group' do
        expect { perform }.to change { WaitForMe::Group.count }.by(-1)
      end
    end
  end
end