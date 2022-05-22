# frozen_string_literal: true

RSpec.describe TicketPayment do
  describe ".call" do
    subject { described_class.call({ id: ticket.id, token: nil, reservation_id: reservation.id }.with_indifferent_access) }

    let(:ticket) { create(:ticket) }
    let(:reservation) { create(:reservation, ticket: ticket) }
    let(:token) { "token" }

    context "when token in not available" do
      it "should raise error" do
        expect { subject }.to raise_error(TicketPayment::TokenNotPresentError)
      end
    end
  end
end
