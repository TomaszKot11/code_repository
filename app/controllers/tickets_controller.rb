# frozen_string_literal: true

class TicketsController < ApiController
  before_action :set_event, only: :index
  before_action :set_tickets, only: :index

  def index
    render :index
  end

  def buy
    # dry-validations for params? or at least validation obj/service?
    @hash_to_serialize = {}
    begin
      # Passing whole in-memory obj is not efficient so we are passing only ids
      TicketPayment.call(payment_params.to_h.with_indifferent_access)
      @hash_to_serialize = { json: { success: "Payment succeeded." }, status: :created }
    rescue TicketPayment::TokenNotPresentError => e
      @hash_to_serialize = { json: { errors: [e.message] }, status: :unprocessable_entity }
      # RecordNotFound can be handled on ApiController layer/in the callback (e.g controller)
    rescue ActiveRecord::RecordNotFound => e
      @hash_to_serialize = { json: { errors: [e.message] }, status: :not_found }
      # Other possible PaymentGate Errors (possibly from wrapping gem)
    rescue StandardError => e
      @hash_to_serialize = { json: { errors: [e.message] }, status: :bad_request }
    end
    render @hash_to_serialize
  end

  private

  def payment_params
    params.permit(:token, :reservation_id, :id)
  end

  def ticket_params
    params.permit(:event_id, :token)
  end

  def set_event
    @event = Event.find(params[:event_id])
  rescue ActiveRecord::RecordNotFound => error
    not_found_error(error)
  end

  def set_tickets
    @tickets = @event.ticket
    if @tickets.present?
      @tickets
    else
      render json: { error: "Ticket not found." }, status: :not_found
    end
  end
end
