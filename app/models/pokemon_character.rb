class PokemonCharacter < ActiveRecord::Base
  def self.characters
    {
      "さみしがり" => [1.1, 0.9, 1, 1, 1],
      "いじっぱり" => [1.1, 1, 0.9, 1, 1],
      "やんちゃ" => [1.1, 1, 1, 0.9, 1],
      "ゆうかん" => [1.1, 1, 1, 1, 0.9],
      "ずぶとい" => [0.9, 1.1, 1, 1, 1],
      "わんぱく" => [1, 1.1, 0.9, 1, 1],
      "のうてんき" => [1, 1.1, 1, 0.9, 1],
      "のんき" => [1, 1.1, 1, 1, 0.9],
      "ひかえめ" => [0.9, 1, 1.1, 1, 1],
      "おっとり" => [1, 0.9, 1.1, 1, 1],
      "うっかりや" => [1, 1, 1.1, 0.9, 1],
      "れいせい" => [1, 1, 1.1, 1, 0.9],
      "おだやか" => [0.9, 1, 1, 1.1, 1],
      "おとなしい" => [1, 0.9, 1, 1.1, 1],
      "しんちょう" => [1, 1, 0.9, 1.1, 1],
      "なまいき" => [1, 1, 1, 1.1, 0.9],
      "おくびょう" => [0.9, 1, 1, 1, 1.1],
      "せっかち" => [1, 0.9, 1, 1, 1.1],
      "ようき" => [1, 1, 0.9, 1, 1.1],
      "むじゃき" => [1, 1, 1, 0.9, 1.1],
    }
  end

  def self.create_character
    self.characters.map do |key, rate_arr|
      PokemonCharacter.create(
        name: key,
        attack: rate_arr[0],
        defend: rate_arr[1],
        sp_attack: rate_arr[2],
        sp_defend: rate_arr[3],
        speed: rate_arr[4]
      )
    end
  end
end
