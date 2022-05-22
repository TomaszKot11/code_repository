# frozen_string_literal: true

class ReservationStatusCheckerJob
  include Sidekiq::Job
  THRESHOLD_MINUTES = 15

  def perform(*args)
    older_than_threshold_minutes = Reservation.where(status: :created)
                                        .where("created_at <= ?", THRESHOLD_MINUTES.minutes.ago)
    older_than_threshold_minutes.update_all(status: :cancelled)
  end
end
