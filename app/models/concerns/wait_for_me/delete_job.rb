module WaitForMe
  module DeleteJob
    extend ActiveSupport::Concern

    def delete_job
      return if job_id.blank?

      Sidekiq::ScheduledSet.new.find_job(job_id)&.delete
    end
  end
end