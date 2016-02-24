class CreateDetails < ActiveRecord::Migration
  def change
    create_table :details do |t|
      t.integer :document_id
      t.jsonb :meta, null: false, default: '{}'
      t.timestamps null: false
    end

    add_index  :details, :document_id
    add_index  :details, :meta, using: :gin
  end
end
