# frozen_string_literal: true

class TicketPayment
  TokenNotPresentError = Class.new(StandardError)

  def self.call(payment_params)
    ticket = Ticket.find(payment_params[:id])
    reservation = Reservation.find(payment_params[:reservation_id])
    payment_token = payment_params[:token]
    raise TokenNotPresentError, "Request body should contain payment token." unless payment_token

    # Assuming no rounding errors while price computation
    Payment::Gateway.charge(amount: ticket.price * reservation.count, token: payment_token)
    reservation.update!(status: :booked)
  end
end
