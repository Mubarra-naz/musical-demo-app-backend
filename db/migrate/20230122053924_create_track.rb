class CreateTrack < ActiveRecord::Migration[6.1]
  def change
    create_table :tracks do |t|
      t.string :name
      t.decimal :price
      t.string :status
      t.references :category

      t.timestamps
    end
  end
end
