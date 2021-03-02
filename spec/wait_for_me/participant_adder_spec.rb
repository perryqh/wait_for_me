require 'rails_helper'

RSpec.describe WaitForMe::ParticipantAdder do
  class AfterWaitingClass
    def self.the_method(p1, p2)
      @@p1 = p1
      @@p2 = p2
    end

    def self.p1
      @@p1
    end

    def self.p2
      @@p2
    end
  end

  let(:execute_after_waiting) { 'AfterWaitingClass.the_method' }
  let(:execute_after_waiting_params) { ['foo', 'bar'] }
  let(:group_key) { 'gkey' }
  let(:participant_key) { 'pkey' }
  let(:number_of_participants_in_group) { 2 }
  let(:wait_time_in_seconds) { 10 }

  subject(:wait) do
    described_class.add(participant_key:                 participant_key,
                        group_key:                       group_key,
                        number_of_participants_in_group: number_of_participants_in_group,
                        execute_after_waiting:           execute_after_waiting,
                        execute_after_waiting_params:    execute_after_waiting_params,
                        wait_time_in_seconds:            wait_time_in_seconds)
  end

  context 'missing params' do
    let(:group_key) { nil }
    let(:participant_key) { nil }
    let(:number_of_participants_in_group) { nil }
    let(:execute_after_waiting) { nil }
    let(:execute_after_waiting_params) { nil }
    let(:wait_time_in_seconds) { nil }
    it 'raises an error' do
      expect { wait }.to raise_error('participant_key is required, group_key is required, number_of_participants_in_group is required, execute_after_waiting is required, wait_time_in_seconds is required')
    end
  end

  let(:created_group) { WaitForMe::Group.last }

  it 'creates group' do
    expect { wait }.to change { WaitForMe::Group.count }.by(1)
    expect(created_group.group_key).to eq(group_key)
    expect(created_group.expected_number_of_participants).to eq(number_of_participants_in_group)
    expect(created_group.execute_after_waiting).to eq(execute_after_waiting)
    expect(created_group.execute_after_waiting_params).to eq(execute_after_waiting_params)
    expect(created_group.wait_time_in_seconds).to eq(wait_time_in_seconds)
    expect(created_group.job_id).to be_present
  end

  it 'enqueues WaitingWorker' do
    wait
    expect(WaitForMe::WaitingWorker).to have_enqueued_sidekiq_job(created_group.group_key).in(wait_time_in_seconds.seconds)
  end

  it 'creates participant' do
    expect { wait }.to change { WaitForMe::Participant.count }.by(1)
    expect(created_group.reload.participants.first.participant_key).to eq(participant_key)
  end

  context 'when a job was already enqueued' do
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

    it 'updates group' do
      expect { wait }.to_not change { WaitForMe::Group.count }
      expect(already_group.reload.group_key).to eq(group_key)
      expect(already_group.expected_number_of_participants).to eq(number_of_participants_in_group)
      expect(already_group.execute_after_waiting).to eq(execute_after_waiting)
      expect(already_group.execute_after_waiting_params).to eq(execute_after_waiting_params)
      expect(already_group.wait_time_in_seconds).to eq(wait_time_in_seconds)
      expect(already_group.job_id).to_not eq(job_id)
    end

    it 'destroys existing job' do
      wait
      expect(scheduled_set).to have_received(:find_job).with(job_id)
      expect(job).to have_received(:delete)
    end

    context 'job not found' do
      let(:job) { nil }

      it 'does not blow up' do
        wait
      end
    end

    context 'all participants arrived' do
      let!(:already_participant) do
        already_group.participants.create(participant_key: 'alreadypkey')
      end

      it 'destroys the group' do
        expect { wait }.to change { WaitForMe::Group.find_by(group_key: already_group.group_key) }.to(nil)
      end

      it 'destroys all the associated participants' do
        expect { wait }.to change { WaitForMe::Participant.where(group_key: already_group.group_key).count }.to(0)
      end

      it 'calls "execute_after_waiting"' do
        wait
        expect(AfterWaitingClass.p1).to eq('foo')
        expect(AfterWaitingClass.p2).to eq('bar')
      end
    end
  end
end