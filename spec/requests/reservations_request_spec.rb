# frozen_string_literal: true

RSpec.describe "Api::V1::Reservations", type: :request do
  describe "POST reservations#create" do
    subject { post api_v1_reservations_path, params: params }

    let(:ticket) { create(:ticket, available: 120) }

    context "invalid params" do
      before { subject }

      context "validations" do
        let(:params) do
          {
            reservation: {
              count: 5,
              user_uid: nil,
              ticket_id: ticket.id
            }
          }
        end

        it "should return proper error message" do
          expect(response_json[:errors]).to match_array(["Validation failed: User uid can't be blank"])
        end

        it "should return proper HTTP status" do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context "too much tickets being reserved" do
        let(:params) do
          {
            reservation: {
              count: ticket.available + 1,
              user_uid: SecureRandom.uuid,
              ticket_id: ticket.id
            }
          }
        end

        it "should return proper error message" do
          expect(response_json[:errors]).to match_array(["You exceeded the number of tickets available by the number 1."])
        end

        it "should return proper HTTP status" do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context "when ticket was not found" do
        let(:params) do
          {
            reservation: {
              count: ticket.available - 10,
              user_uid: SecureRandom.uuid,
              ticket_id: -1
            }
          }
        end

        it "should return proper error message" do
          expect(response_json[:errors]).to match_array(["Couldn't find Ticket with 'id'=-1"])
        end

        it "should return proper HTTP status" do
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context "valid params" do
      let(:params) do
        {
          reservation: {
            count: ticket.available - 10,
            user_uid: SecureRandom.uuid,
            ticket_id: ticket.id
          }
        }
      end

      it "should create reservation" do
        expect { subject }.to change { Reservation.count }.by(1)
      end

      it "should create reservation for ticket" do
        subject
        last_created_reservation = Reservation.last

        expect(last_created_reservation.ticket.id).to eq(ticket.id)
        expect(last_created_reservation.user_uid).to eq(params.dig(:reservation, :user_uid))
      end
    end
  end
end
