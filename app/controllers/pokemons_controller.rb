class PokemonsController < ApplicationController
  before_action :set_pokemon, only: [:calculate]
  before_action :set_pokemon_racial_params, only: [:calculate]

  def new
    @pokemon = Pokemon.new
  end

  def calculate
    @pokemon.ability_calculate(pokemon_params[:level].to_i, params[:character_id])
    render 'new'
  end

  private

    def set_pokemon
      @pokemon = Pokemon.find_by(number: pokemon_params[:number])
    end

    def pokemon_params
      params[:pokemon]
    end

    def set_pokemon_racial_params
      [:p, :tr].each do |prefix|
        [:hp, :attack, :defend, :sp_attack, :sp_defend, :speed].each do |ability|
          full_ability_name = prefix.to_s + '_' + ability.to_s
          @pokemon.send("#{full_ability_name}=", pokemon_params[full_ability_name.to_s].to_i || 0)
        end
      end
    end
end
