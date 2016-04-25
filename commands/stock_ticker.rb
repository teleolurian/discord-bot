class SisterMercy::Commands::StockTicker < SisterMercy::Command
  def self.name; :stock; end

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

  def description
    'Gets a quote for a stock ticker'
  end


  def execute(event, stock)
    get_quote(stock)
  end
end


