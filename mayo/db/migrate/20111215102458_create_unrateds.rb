class CreateUnrateds < ActiveRecord::Migration
  def change
    create_table :unrateds do |t|

      t.timestamps
    end
  end
end
