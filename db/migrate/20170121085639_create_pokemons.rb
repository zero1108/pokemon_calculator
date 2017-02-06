class CreatePokemons < ActiveRecord::Migration
  def change
    create_table :pokemons do |t|
      t.integer :number
      t.integer :hp
      t.integer :attack
      t.integer :defend
      t.integer :sp_attack
      t.integer :sp_defend
      t.integer :speed
      t.timestamps null: false
    end
  end
end
