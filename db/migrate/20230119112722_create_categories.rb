class CreateCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.references :category, foreign_key: { to_table: :categories }

      t.timestamps
    end
  end
end
