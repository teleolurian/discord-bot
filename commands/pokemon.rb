require 'json'
require 'open-uri'

class SisterMercy::Commands::Pokemon < SisterMercy::Command
  def self.name; :pokemon; end
  def get_pokemon(name)
    a = open("https://pokeapi.co/api/v2/pokemon/#{name}/")
    JSON.parse a.read
  end


  def execute(event, *nm)
    pokemon = get_pokemon(nm.join(?-).chomp.downcase)
    types = pokemon['types'].map {|x| x['type']['name']}.join ?/
    imgurl = pokemon["sprites"]["front_default"]
    abilities = pokemon['abilities'].map {|x| x['ability']['name']}.join ', '
    "#{pokemon['name']}\nTypes: #{types}\nAbilities: #{abilities}\n#{imgurl}"
  end
end


