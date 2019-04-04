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
