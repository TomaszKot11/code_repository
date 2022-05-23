# frozen_string_literal: true

class ApiController < ApplicationController
  rescue_from Payment::Gateway::CardError, Payment::Gateway::PaymentError,
              with: :payment_failed_error

  private

  def not_found_error(error)
    render json: { error: error.message }, status: :not_found
  end

  def payment_failed_error(error)
    render json: { error: error.message }, status: :payment_required
  end
end
