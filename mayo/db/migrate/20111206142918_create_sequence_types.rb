class CreateSequenceTypes < ActiveRecord::Migration
  def change
    create_table :sequence_types do |t|
      t.string :description

      t.timestamps
    end
  end
end
