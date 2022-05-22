# frozen_string_literal: true

class Api::V1::ReservationsController < ApiController
  def create
    @hash_to_serialize = {}
    begin
      @hash_to_serialize = { json: TicketReservation.call(reservation_params.to_h.with_indifferent_access), status: :created }
      # "Typical exceptions" can be also caught on ApiController level
    rescue ActiveRecord::RecordNotFound => e
      @hash_to_serialize = { json: { errors: [e.message] }, status: :not_found }
    rescue ActiveRecord::RecordInvalid, TicketReservation::ReservationNotEnoughTicketsError => e
      @hash_to_serialize = { json: { errors: [e.message] }, status: :unprocessable_entity }
    rescue ActiveModel::ValidationError => e
      @hash_to_serialize = { json: { errors: e.errors }, status: :unprocessable_entity }
    rescue StandardError => e
      @hash_to_serialize = { json: { errors: [e.message] }, status: :bad_request }
    end
    # Using default Rails json serializer
    render @hash_to_serialize
  end

  private

  def reservation_params
    params.require(:reservation).permit(:ticket_id, :user_uid, :count)
  end
end
