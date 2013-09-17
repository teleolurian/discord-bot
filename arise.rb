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
      begin
        YahooFinance.get_quotes(YahooFinance::StandardQuote, sym) do |quote|
          retval = "[#{quote.symbol}] $#{quote.lastTrade} @ #{quote.date}"
        end
      rescue
        retval = "There was an error fetching the quote."
      end
      retval
    end
  end

  on :message, /^\$ (\w+)/ do |m, query|
    m.reply get_quote(query)
  end
end

bot.start
  