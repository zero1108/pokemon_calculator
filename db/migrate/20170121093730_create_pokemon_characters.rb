class CreatePokemonCharacters < ActiveRecord::Migration
  def change
    create_table :pokemon_characters do |t|
      t.string :name
      t.decimal :attack
      t.decimal :defend
      t.decimal :sp_attack
      t.decimal :sp_defend
      t.decimal :speed
      t.timestamps null: false
    end
    PokemonCharacter.create_character
  end
end
