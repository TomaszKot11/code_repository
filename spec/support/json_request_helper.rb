# frozen_string_literal: true

module JsonRequestHelpers
  def response_json
    JSON.parse(response.body).deep_symbolize_keys
  end
end
