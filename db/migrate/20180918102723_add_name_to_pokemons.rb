class AddNameToPokemons < ActiveRecord::Migration[5.2]
  def change
    unless column_exists? :pokemons, :name
      add_column :pokemons, :name, :string
    end
  end
end
