require 'rails_helper'

RSpec.describe WaitForMe::CallExecuteAfterWaiting do
  class TestCall
    include WaitForMe::CallExecuteAfterWaiting
    attr_accessor :execute_after_waiting, :execute_after_waiting_params
  end

  let(:execute_after_waiting) { 'Foo::Jimmy.baz' }
  let(:execute_after_waiting_params) { ['foo'] }

  subject(:wait) do
    tc                              = TestCall.new
    tc.execute_after_waiting        = execute_after_waiting
    tc.execute_after_waiting_params = execute_after_waiting_params
    tc
  end

  its(:execute_after_waiting_class) { is_expected.to eq('Foo::Jimmy') }
  its(:execute_after_waiting_method) { is_expected.to eq('baz') }

  describe '#call_execute_after_waiting' do
    let(:execute_after_waiting) { 'Foo::CallMe.baz' }
    let(:execute_after_waiting_params) { ['foo'] }

    it 'calls CallThisClass.baz' do
      wait.call_execute_after_waiting
      expect(Foo::CallMe.arg1).to eq('foo')
    end

    context 'when method takes no args' do
      let(:execute_after_waiting) { 'Foo::CallMe.no_args_method' }
      let(:execute_after_waiting_params) { nil }

      it 'calls CallThisClass.no_args_method' do
        wait.call_execute_after_waiting
        expect(Foo::CallMe.no_args_method_called).to be_truthy
      end
    end
  end
end