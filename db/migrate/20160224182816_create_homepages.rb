class CreateHomepages < ActiveRecord::Migration
  def change
    create_table :homepages do |t|
      t.integer :document_id
      t.timestamps null: false
    end

    add_index  :homepages, :document_id
  end
end
