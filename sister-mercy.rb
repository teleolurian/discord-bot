require 'rubygems'
require 'bundler/setup'
require './auth'
Bundler.require(:default)

class SisterMercy
  attr_reader :bot
  def initialize
    @bot = Discordrb::Commands::CommandBot.new token: USER_TOKEN, application_id: 174210304329252864, prefix: '!'
    init_commands
    @bot.join "https://discord.gg/0pfFGCNCXtAAxfkW"
    @bot.run
  end

  def get_quote(sym)
    retval = nil
    YahooFinance.get_quotes(YahooFinance::StandardQuote, sym) do |quote|
      retval = "[#{quote.symbol}] #{quote.name} $#{quote.lastTrade} #{quote.change} #{quote.time}"
    end
    retval
  end

  def get_extended_quote(sym, command)
    sym = sym.to_s.upcase
    quote = YahooFinance.get_quotes(YahooFinance::ExtendedQuote, sym)[sym]
    available_methods = quote.public_methods(nil).grep(/\=$/).sort.collect {|x| x.to_s.sub(/\=$/, '')}
    reply = "There was a problem getting your information."
    if available_methods.include?(command)
      reply = "$#{sym} #{command}: #{quote.send(command.intern)}"
    else
      reply = "Available commands: "
      reply += available_methods.join(',')
    end
  end

  def init_commands
    @bot.command(:stock, min_args: 1, max_args: 1, description: 'Gets a quote for a stock ticker') do |event, symbol|
      event << get_quote(symbol)
    end
  end
end


sister_mercy = SisterMercy.new



