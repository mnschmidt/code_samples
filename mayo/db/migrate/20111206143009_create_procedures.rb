class CreateProcedures < ActiveRecord::Migration
  def change
    create_table :procedures do |t|
      t.integer :code
      t.string :description
      t.string :contact
      t.text :note

      t.timestamps
    end
  end
end
