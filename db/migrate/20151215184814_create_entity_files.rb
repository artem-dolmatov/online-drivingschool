class CreateEntityFiles < ActiveRecord::Migration
  def change
    create_table :entity_files do |t|
      t.string :entity
      t.integer :entity_id
      t.string :name
      t.string :file
      t.integer :main
      t.string :title
      t.string :content_type
      t.string :original_filename
      t.string :content_type
      t.string :size
      t.text :desc
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
