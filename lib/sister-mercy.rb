require 'uri'
require 'net/http'
require 'json'
require 'hashie'
require 'htmlentities'
require 'hpricot'

class String
  def +@
    HTMLEntities.new.decode(self)
  end
end

class Array
  def random
    self[(rand() * (self.length - 1)).to_i]
  end
end

class SisterMercy
  Registry = {}
  attr_reader :bot

  def initialize
    @bot = Discordrb::Commands::CommandBot.new token: AUTH_TOKEN, client_id: 174210304329252864, prefix: '!', application_id: 174210304329252864
    puts @bot.invite_url
    init_commands
  end

  def run; @bot.run; end

  def init_commands
    Registry.each_pair do |key, handler|
      @bot.command(key) {|*args| handler.execute(*args)}
    end
  end

  def self.load_commands(directory)
    Dir.glob(directory + '/*.rb').each {|fl| load fl}
    SisterMercy::Commands.constants.each do |sym|
      SisterMercy::Commands.const_get(sym).register
    end
  end
end

class SisterMercy::Commands; end
class SisterMercy::Command
  class << self
    def name; :command; end
    def register
      SisterMercy::Registry[self.name] = self.new
      puts "Loaded #{self.name}"
    end
  end

  def execute(event, *args)
    "I don't understand that command!"
  end

  def hpricot(url)
    Hpricot(get_raw_json_from(url))
  end

  def get_raw_json_from(url)
    Net::HTTP.get(URI.parse(url))
  end

  def get_json_from(url)
    Hashie::Mash.new(JSON.parse(get_raw_json_from(url)))
  end
end
