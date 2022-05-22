# frozen_string_literal: true

RSpec.describe Reservation, type: :model do
  describe "validations" do
    it { should validate_presence_of(:count) }
    it { should validate_presence_of(:user_uid) }
    it { should define_enum_for(:status).with_values(created: 0, booked: 1, cancelled: 2) }
  end

  describe "associations" do
    it { should belong_to(:ticket) }
  end
end
