class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :name
      t.string :seo_url
      t.integer :document_type_id
      t.integer :status_id
      t.timestamps null: false
    end

    add_index  :documents, :seo_url
    add_index  :documents, :document_type_id
    add_index  :documents, :status_id
  end
end
