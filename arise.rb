require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

bot = Cinch::Bot.new do
  configure do |c|
    c.server    = 'irc.bashzen.net'
    c.nick      = 'SisterMercy'
    c.channels  = ['#smash3000']
  end

  helpers do
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
  end


  on :message, /^\$\s*([A-Za-z\.]+)/ do |m, query|
    m.reply get_quote(query)
  end
  on :message, /^\$\$\s*([A-Za-z\.]+)\:(\w+)/ do |m, query, command|
    m.reply get_extended_quote(query, command)
  end
end

bot.start
