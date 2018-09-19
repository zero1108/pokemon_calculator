require 'open-uri'
require 'net/http'
class Pokemon < ActiveRecord::Base
  attr_accessor :character, :level, :p_hp, :p_attack, :p_defend, :p_sp_attack, :p_sp_defend, :p_speed, :tr_hp, :tr_attack, :tr_defend, :tr_sp_attack, :tr_sp_defend, :tr_speed, :real_hp, :real_attack, :real_defend, :real_sp_attack, :real_sp_defend, :real_speed

  validates_uniqueness_of :number

  DATA_HOST = 'https://yakkun.com/sm/zukan/'
  MAX_NO = 807
  THREAD_BUCKET = 300

  has_one_attached :icon

  def self.personal_ability
    %W( hp attack defend sp_attack sp_defend speed)
  end

  # 能力値＝(種族値×2＋個体値＋努力値÷4)×レベル÷100＋レベル＋10
  # 能力値＝{(種族値×2＋個体値＋努力値÷4)×レベル÷100＋5}×性格補正
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

  class << self
    def sync
      thread_count = MAX_NO/THREAD_BUCKET + (MAX_NO%THREAD_BUCKET > 0 ? 1 : 0)
      thread_count.times do |index|
        numbers = MAX_NO - (index + 1) * THREAD_BUCKET > 0 ? THREAD_BUCKET : MAX_NO - index * THREAD_BUCKET
        thread = Thread.new do
          pokemons = []
          numbers.times do |number|
            uri = URI("#{DATA_HOST}n#{number + index * THREAD_BUCKET + 1}")
            result = Net::HTTP.get(uri)
            doc = Nokogiri::HTML(result)
            pokemons << parse_from_html(doc)
          end
          Pokemon.import pokemons
        end
        thread.join
      end
    end

    def parse_from_html(doc)
      status_part = doc.xpath('//div[@class="table layout_right"]/table/tr/td[@class="left"]')
      number = doc.xpath('//div[@class="table layout_left"]/table/tr[@class="center"]/td')[2].text.to_i
      name = doc.xpath('//div[@class="table layout_left"]/table/tr/th').children.first.text
      hp = status_part[0].text.to_i
      attack = status_part[1].text.to_i
      defend = status_part[2].text.to_i
      sp_attack = status_part[3].text.to_i
      sp_defend = status_part[4].text.to_i
      speed = status_part[5].text.to_i

      avatar_url = doc.xpath('//div[@class="table layout_left"]/table/tr[@class="center"]/td/img/@src').text.gsub('//', 'http://')
      avatar = open(avatar_url)

      pokemon = Pokemon.new({
        number: number,
        name: name,
        hp: hp,
        attack: attack,
        defend: defend,
        sp_attack: sp_attack,
        sp_defend: sp_defend,
        speed: speed
        })
      pokemon.icon.attach(io: avatar, filename: "#{number}.jpg")
      pokemon
    end
  end

end
