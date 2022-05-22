class CreateReservations < ActiveRecord::Migration[6.0]
  def change
    create_table :reservations do |t|
      t.string :user_uid
      t.integer :status, default: 0
      t.integer :count, null: false
      t.references :ticket, index: true, foreign_key: { to_table: :tickets }
      t.timestamps
      # Rails 6.1
      # t.check_constraint "count_check", "count >= 1"
    end
  end
end
