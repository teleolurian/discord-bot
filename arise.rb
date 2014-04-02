require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

bot = Cinch::Bot.new do
  configure do |c|
    c.server    = '71.19.149.156'
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

    def get_extended_quote(sym, commands)
      sym = sym.upcase
      quote = YahooFinance.get_quotes(YahooFinance::ExtendedQuote, sym)[sym]
      commands = commands.split(/\s+/)
      available_methods = quote.public_methods(nil).grep(/\=$/).sort.collect {|x| x.to_s.sub(/\=$/, '')}
      return "Symbol not found!" unless available_methods.length > 0
      reply = []
      commands.each {|command| reply << "#{command}: #{quote.send(command.intern)}" if available_methods.include?(command) }
      if reply.length > 0
        "$#{sym}: " + reply.join(' ')
      else
        reply = "Available commands: "
        reply += available_methods.join(',')
      end
    end
  end


  on :message, /^\$\s*([A-Za-z\.]+)/ do |m, query|
    m.reply get_quote(query)
  end
  on :message, /^\$\$\s*([A-Za-z\.]+)\s*(.*)/ do |m, query, command|
    m.reply get_extended_quote(query, command)
  end
end

bot.start
