class CreateNijmegenSchedulings < ActiveRecord::Migration
  def change
    create_table :nijmegen_schedulings do |t|

      t.timestamps
    end
  end
end
