# frozen_string_literal: true

class TicketReservation
  ReservationNotEnoughTicketsError = Class.new(StandardError)

  def self.call(creational_params)
    ticket_blueprint = Ticket.find(creational_params[:ticket_id])
    reservations_count = Reservation.where(status: :processed).or(Reservation.where(status: :booked)).sum(:count)

    new_reservation = Reservation.new(creational_params)
    new_reservation.validate!

    raise ReservationNotEnoughTicketsError, "You exceeded the number of tickets available by the number #{(reservations_count + new_reservation.count) - ticket_blueprint.available}." if (reservations_count + new_reservation.count) > ticket_blueprint.available

    new_reservation.save!
  end
end
