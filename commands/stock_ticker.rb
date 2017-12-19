require 'tempfile'
require 'open-uri'

class SisterMercy::Commands::StockTicker < SisterMercy::Command
  def self.name; :stock; end

  def get_quote(sym)
    retval = nil
    YahooFinance.get_quotes(YahooFinance::StandardQuote, sym) do |quote|
      price = quote.lastTrade % "%0.2f"
      retval = "[#{quote.symbol}] #{quote.name} $#{price} #{quote.change} #{quote.time}"
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


class SisterMercy::Commands::StockChart < SisterMercy::Command
  def self.name; :chart; end

  def description
    'Stock charts'
  end

  def execute(event, stock, time="5MIN")
    #"http://chart.finance.yahoo.com/t?s=#{stock}&lang=en-US&region=US&width=300&height=180"
    #"http://chart.finance.yahoo.com/b?s=#{stock}&t=1d&q=c&l=on&z=s"
    return "Invalid time type" unless time =~ /\d+(min|year|month|day)/i
    url = "https://widgets.tc2000.com/ChartImageHandler.ashx?service=TCTEMPLATE&symwatermark=f&useTemplateSettings=false&sym=#{stock}&w=400&h=275&ID=9540445&TF=#{time}&bars=40#s.png"
    a = open(url).read
    t = Tempfile.new(['stock','.png'])
    t.write(a)
    t.seek(0)
    event.bot.send_file(event.channel.id, t)
    t.close
    nil
  end
end
