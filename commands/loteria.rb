LA_CARTA = [
  'El Gallo, The Rooster',
  'El Diablito, The Little Devil',
  'La Dama, The Lady',
  'El Catrin, The Dandy',
  'El Paraguas, The Umbrella',
  'La Sirena, The Mermaid',
  'La Escalera, The Ladder',
  'La Botella, The Bottle',
  'El Barril, The Barrel',
  'El Arbol, The Tree',
  'El Melon, The Melon',
  'El Valiente, The Brave Man',
  'El Gorrito, The Little Bonnet',
  'La Muerte, Death',
  'La Pera, The Pear',
  'La Bandera, The Flag',
  'El Bandolon, The Mandolin',
  'El Violoncello, The Cello',
  'La Garza, The Heron',
  'El Pajaro, The Bird',
  'La Mano, The Hand',
  'La Bota, The Boot',
  'La Luna, The Moon',
  'El Cotorro, The Parrot',
  'El Borracho, The Drunkard',
  'El Negrito, The Little Black Man',
  'El Corazon, The Heart',
  'La Sandia, The Watermelon',
  'El Tambor, The Drum',
  'El Camaron, The Shrimp',
  'Las Jaras, The Arrows',
  'El Musico, The Musician',
  'La Arana, The Spider',
  'El Soldado, The Soldier',
  'La Estrella, The Star',
  'El Cazo, The Saucepan',
  'El Mundo, The World',
  'El Apache, The Apache',
  'El Nopal, The Prickly Pear Cactus',
  'El Alacran, The Scorpion',
  'La Rosa, The Rose',
  'La Calavera, The Skull',
  'La Campana, The Bell',
  'El Cantarito, The Little Water Pitcher',
  'El Venado, The Deer',
  'El Sol, The Sun',
  'La Corona, The Crown',
  'La Chalupa, The Canoe',
  'El Pino, The Pine Tree',
  'El Pescado, The Fish',
  'La Palma, The Palm Tree',
  'La Maceta, The Flowerpot',
  'El Arpa, The Harp',
  'La Rana, The Frog'
]

class SisterMercy::Commands::Loteria < SisterMercy::Command
  def self.name; :loteria; end

  def description
    'Loteria Cards'
  end

  def execute(event, *args)
    ln = LA_CARTA.length
    cards = 3.times.map {|x| LA_CARTA[(rand() * ln).to_i] }
    +cards.join(' | ')
  end
end
