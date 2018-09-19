class AddIndexToPokemon < ActiveRecord::Migration[5.2]
  def change
    unless index_exists? :pokemons, :number
      add_index :pokemons, :number, unique: true
    end
  end
end
