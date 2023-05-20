class CreateBedTimeHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :bed_time_histories do |t|
      t.datetime :bed_time
      t.datetime :wake_up_time
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
