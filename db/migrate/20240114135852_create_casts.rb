class CreateCasts < ActiveRecord::Migration[7.0]
  def change
    create_table :casts do |t|
      t.string :role, index: true
      t.belongs_to :movie, null: false, foreign_key: true
      t.belongs_to :person, null: false, foreign_key: true

      t.timestamps
    end
  end
end
