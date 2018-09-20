class PokemonsController < ApplicationController
  before_action :set_pokemon, only: [:show]
  before_action :pokemon_params, :set_racial_ability_params, only: [:calculate]

  def show
    render json: @pokemon
  end

  def new
    @pokemon = Pokemon.new
    @pokemons = Pokemon.collection
  end

  def calculate
    personal_abilities = {}
    train_abilities = {}
    personal_abilities.merge!(
      :hp => pokemon_params[:p_hp].to_i || 0,
      :attack => pokemon_params[:p_attack].to_i || 0,
      :defend => pokemon_params[:p_defend].to_i || 0,
      :sp_attack => pokemon_params[:p_sp_attack].to_i || 0,
      :sp_defend => pokemon_params[:p_sp_defend].to_i || 0,
      :speed => pokemon_params[:p_speed].to_i || 0,
    )
    train_abilities.merge!(
      :hp => pokemon_params[:tr_hp].to_i || 0,  
      :attack => pokemon_params[:tr_attack].to_i || 0,  
      :defend => pokemon_params[:tr_defend].to_i || 0,  
      :sp_attack => pokemon_params[:tr_sp_attack].to_i || 0, 
      :sp_defend => pokemon_params[:tr_sp_defend].to_i || 0,  
      :speed => pokemon_params[:tr_speed].to_i || 0,
    )
    @abilities = @pokemon.ability_calculate(personal_abilities, train_abilities, pokemon_params[:level].to_i, params[:character_id])
    render 'new'
  end

  private
    def pokemon_params
      params[:pokemon]
    end

    def set_racial_ability_params
      @pokemon = Pokemon.new(
        hp: pokemon_params[:hp],
        attack: pokemon_params[:attack],
        defend: pokemon_params[:defend],
        sp_attack: pokemon_params[:sp_attack],
        sp_defend: pokemon_params[:sp_defend],
        speed: pokemon_params[:speed],
      )
    end

    def set_pokemon
      @pokemon = Pokemon.find_by(number: params[:id])
    end
end
