class CreateParticipants < ActiveRecord::Migration[5.2]
  def change
    create_table :wait_for_me_groups do |t|
      t.string :group_key, null: false
      t.string :job_id
      t.string :execute_after_waiting
      t.string :execute_after_waiting_params, array: true
      t.integer :expected_number_of_participants
      t.integer :wait_time_in_seconds
      t.timestamps
    end
    add_index :wait_for_me_groups, :group_key, unique: true

    create_table :wait_for_me_participants do |t|
      t.string :participant_key, null: false
      t.string :group_key, null: false
      t.timestamps
    end
    add_index :wait_for_me_participants, :participant_key, unique: true
  end
end
