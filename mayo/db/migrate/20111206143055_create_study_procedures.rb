class CreateStudyProcedures < ActiveRecord::Migration
  def change
    create_table :study_procedures do |t|
      t.integer :procedure_id
      t.integer :study_id
      t.integer :order_index

      t.timestamps
    end
  end
end
