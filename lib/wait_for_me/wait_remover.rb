module WaitForMe
  class WaitRemover
    attr_reader :group_key

    def initialize(group_key)
      @group_key = group_key
    end

    def self.remove_wait(group_key)
      new(group_key).remove_wait
    end

    def remove_wait
      return unless group

      group.delete_job
      group.destroy
    end

    def group
      @group ||= Group.where(group_key: group_key).first
    end
  end
end