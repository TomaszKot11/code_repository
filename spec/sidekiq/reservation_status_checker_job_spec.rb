# frozen_string_literal: true

require "rails_helper"

RSpec.describe ReservationStatusCheckerJob, type: :job do
  let(:past_threshold) { ReservationStatusCheckerJob::THRESHOLD_MINUTES + 1 }
  let(:earlier_than_threshold) { ReservationStatusCheckerJob::THRESHOLD_MINUTES - 1 }
  let(:reservations_older_than_threshold)  { create_list(:reservation, 5, created_at: Time.current - past_threshold.minutes) }
  let(:reservation_earlier_than_threshold) { create_list(:reservation, 5, created_at: Time.current - earlier_than_threshold.minutes) }
  let(:time_now) { Time.current }

  context "reservation management" do
    it "should change status accurately" do
      allow(Time).to receive(:current).and_return(time_now)
      reservations_older_than_threshold
      reservation_earlier_than_threshold

      ReservationStatusCheckerJob.new.perform({})

      reservations_older_than_threshold.each(&:reload)
      reservation_earlier_than_threshold.each(&:reload)

      expect(reservations_older_than_threshold.pluck(:status).uniq).to eq(["cancelled"])
      expect(reservation_earlier_than_threshold.pluck(:status).uniq).to eq(["created"])
    end
  end
end
