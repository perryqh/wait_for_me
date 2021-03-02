require 'rails_helper'

RSpec.describe WaitForMe::WaitRemover do
  describe '#remove_wait' do
    subject(:remove) { described_class.remove_wait(group_key) }

    context 'when group does not exist' do
      let(:group_key) { 'does not exist' }
      it 'does not blow up' do
        expect(remove).to be_nil
      end
    end

    context 'when group does exist' do
      let(:group_key) { 'blog-13' }
      let(:job_id) { 'asdf23' }
      let!(:already_group) { create(:wait_for_me_group, group_key: group_key,
                                    job_id:                        job_id) }
      let(:scheduled_set) { instance_double(Sidekiq::ScheduledSet) }
      let(:job) { double(:job) }
      before do
        allow(Sidekiq::ScheduledSet).to receive(:new).and_return(scheduled_set)
        allow(scheduled_set).to receive(:find_job).and_return(job)
        allow(job).to receive(:delete)
      end

      it 'destroys the group' do
        expect { remove }.to change { WaitForMe::Group.count }.by(-1)
      end

      it 'deletes the job' do
        remove
        expect(job).to have_received(:delete)
      end
    end
  end
end