class Pokemon < ActiveRecord::Base
  attr_accessor :character, :level, :p_hp, :p_attack, :p_defend, :p_sp_attack, :p_sp_defend, :p_speed, :tr_hp, :tr_attack, :tr_defend, :tr_sp_attack, :tr_sp_defend, :tr_speed, :real_hp, :real_attack, :real_defend, :real_sp_attack, :real_sp_defend, :real_speed

  # 能力値＝(種族値×2＋個体値＋努力値÷4)×レベル÷100＋レベル＋10
  # 能力値＝{(種族値×2＋個体値＋努力値÷4)×レベル÷100＋5}×性格補正

  def self.personal_ability
    %W( hp attack defend sp_attack sp_defend speed)
  end

  def ability_calculate(personal_abilities, train_abilities, level, character_id)
    abilities = []
    self.level = level
    pokemon_character = PokemonCharacter.find(character_id)
    Pokemon.personal_ability.each do |ability|
      if ability == "hp"
        abilities << (self.send(ability)*2+personal_abilities[ability.to_sym]+train_abilities[ability.to_sym]/4)*level/100+level+10
      else
        abilities << ((self.send(ability)*2+personal_abilities[ability.to_sym]+train_abilities[ability.to_sym]/4)*level/100+5)*pokemon_character.send(ability)
      end
    end
    abilities.map(&:to_i)
  end

  # def self.sync
  #   url = "http://yakkun.com/sm/zukan/n722"
  # end

end
