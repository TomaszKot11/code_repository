# frozen_string_literal: true

RSpec.describe "Tickets", type: :request do
  shared_examples "event not found" do
    it "should have correct HTTP status" do
      expect(response).to have_http_status(:not_found)
    end

    it "should render error" do
      expect(response_json).to eq({ error: "Couldn't find Event with 'id'=incorrect" })
    end
  end

  describe "GET tickets#index" do
    context "event exists" do
      subject { get "/tickets", params: params }

      let(:params) { { event_id: event.id } }

      before { subject }

      context "ticket exists" do
        let(:event) { create(:event, :with_ticket) }
        let(:ticket) { event.ticket }

        it "should have correct HTTP status" do
          expect(response).to have_http_status(:ok)
        end

        it "should have correct size" do
          expect(response_json.size).to eq(1)
        end

        it "should render event" do
          expect(response_json).to include(
            tickets: hash_including(
              available: ticket.available,
              price: ticket.price.to_s,
              event: hash_including(
                id: event.id,
                name: event.name,
                formatted_time: event.formatted_time
              )
            )
          )
        end
      end

      context "ticket does not exist" do
        let(:event) { create(:event) }

        it "should have correct HTTP status" do
          expect(response).to have_http_status(:not_found)
        end

        it "should render error" do
          expect(response_json).to eq({ error: "Ticket not found." })
        end
      end
    end

    context "event does not exist" do
      let(:params) { { event_id: "incorrect" } }

      before { get "/tickets", params: params }

      it_behaves_like "event not found"
    end
  end

  describe "POST tickets#buy" do
    let(:ticket) { create(:ticket) }
    let(:reservation) { create(:reservation, ticket: ticket) }
    subject { post buy_ticket_path(ticket), params: params }

    before { subject }

    context "ticket and reservation exists" do
      let(:params) { { reservation_id: reservation.id, token: "token" } }

      it "reservation should be processed" do
        reservation.reload
        expect(reservation.status).to eq("booked")
      end

      it "proper HTTP status should be returned" do
        expect(response).to have_http_status(:created)
      end
    end

    context "ticket or reservation does not exist" do
      let(:params) { { reservation_id: -1, token: "token" } }

      it "should return error" do
        expect(response_json[:errors]).to match_array(["Couldn't find Reservation with 'id'=-1"])
      end

      it "should return proper HTTP status" do
        expect(response).to have_http_status(:not_found)
      end
    end

    context "Params validation error" do
      subject { post buy_ticket_path(ticket), params: params }

      before { subject }

      let(:params) do
        {
          reservation_id: reservation.id
        }
      end

      it "should return error" do
        expect(response_json[:errors]).to match_array(["Request body should contain payment token."])
      end

      it "should return HTTP status" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
