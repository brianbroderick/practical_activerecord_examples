class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :document_id
      t.integer :up_vote
      t.integer :down_vote
      t.timestamps null: false
    end

    add_index  :ratings, :document_id
  end
end
