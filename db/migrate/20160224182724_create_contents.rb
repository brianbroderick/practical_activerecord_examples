class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.integer :document_id
      t.text :body
      t.timestamps null: false
    end

    add_index  :contents, :document_id
  end
end
