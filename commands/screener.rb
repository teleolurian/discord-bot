class SisterMercy::Commands::Screener < SisterMercy::Command
  FV = Hashie::Mash.new({
    host:     'https://finviz.com',
    quote:    '/quote.ashx?t=%',
    screener: '/screener.ashx?%'
  })
  
  TERMS = IO.readlines('./commands.psv').map do |row|
    name, readable, match = row.split(?|,3).map(&:chomp)
    {name: name, readable: readable, match: Regexp.new(match, ?i)}
  end
  
  HELP_MESSAGES = {
    :short => "Use !screener stats [ticker] [statistic]",
  }
  
  ALLOWED_COMMANDS = [:help, :stats]
  
  def self.name; :screener; end
  
  def fetch_response(path, tok)
    url = (FV.host + FV[path]).sub(/%/, tok)
    puts "fetching #{url}..."
    hpricot(url) rescue nil
  end
  
  def stats(stock, *args)
    args = args.join(' ').chomp
    result = fetch_response(:quote, stock)
    data = (result / 'table.snapshot-table2')[0]
    return ["not found"] unless data
    cells = data / 'td'
    h = {}
    0.step(cells.length-1, 2){|i| h[cells[i].innerText] = (cells[i+1].innerText rescue nil)}
    response = []
    TERMS.each do |term|
      if args =~ term[:match]
        response.push [term[:readable], h[term[:name]]].join(': ')
      end
    end
    response
  end
  
  def help_message(cmd)
    [HELP_MESSAGES[cmd.intern]]
  end
  
  def execute(event, command, *args)
    cmd = command.downcase.to_sym
    if ALLOWED_COMMANDS.include?(cmd)
      response = self.send(cmd, *args)
    else
      self.help_message('short')
    end
    response = [response] unless response.is_a?(Array)
    response.join $/
  end
end
