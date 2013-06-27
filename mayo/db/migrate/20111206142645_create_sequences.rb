class CreateSequences < ActiveRecord::Migration
  def change
    create_table :sequences do |t|
      t.integer :sequence_type_id
      t.string :name
      t.integer :length

      t.timestamps
    end
  end
end
