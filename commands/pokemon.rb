class SisterMercy::Commands::Pokemon < SisterMercy::Command
  def self.name; :pokemon; end
  def get_pokemon(name)
    get_json_from "http://pokeapi.co/api/v2/pokemon/#{name}/"
  end


  def execute(event, nm)
    pokemon = get_pokemon(nm.downcase)
    types = pokemon.types.map {|x| x.type.name}.join ?/
    abilities = pokemon.abilities.map {|x| x.ability.name}.join ', '
    "#{pokemon.name} (#{types}) - #{abilities}"
  end
end


