# frozen_string_literal: true

RSpec.describe TicketReservation do
  describe ".call" do
    subject { described_class.call(reservation_attrs.with_indifferent_access) }

    let(:ticket) { create(:ticket, available: 20) }
    let(:reservation_attrs) { attributes_for(:reservation, ticket_id: ticket.id, count: 21) }

    context "when user want to reserve to much tickets" do
      it "should raise error" do
        expect { subject }.to raise_error(TicketReservation::ReservationNotEnoughTicketsError)
      end
    end
  end
end
