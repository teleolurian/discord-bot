class SisterMercy::Commands::Screener < SisterMercy::Command
  FV = Hashie::Mash.new({
    host:     'https://finviz.com',
    quote:    '/quote.ashx?t=%',
    screener: '/screener.ashx?%'
  })
  
  TERMS = IO.readlines(DATA).map do |row|
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
__END__
Index           | Stock Market Index                     | index
P/E             | Profit / Earnings  (if profitable)     | p(?:rofit)\s*(?:and|&|\/)*\s*e(?:arnings)
EPS (ttm)       | Diluted Earnings per Share             | (?:diluted)*\s*e(?:arnings)*\s*p(?:er)*\s*s(?:hare)\s*(?:\(ttm\))
Insider Own     | % Insider Owned                        | insider?(?:\s*(?:own(?:er|ed|ership)))
Shs Outstand    | Outstanding Shares OTM                 | sh(?:are)*s\s*outstand(?:ing)*|outstand(?:ing)*\s*sh(?:are)*s
Perf Week       | Price Performance (week)               | perf(?:ormance)*\s*week(?:ly)*|week(?:ly)*\s*perf(?:ormance)*
Market Cap      | Market Capitalization                  | m(?:ar)*ke?t\scap(?:italization)*
Forward P/E     | Profit / Earnings (1y Forecast)        | fo?rwa?r?d\sp(?:rofit)\s*(?:and|&|\/)*\s*e(?:arnings)
EPS next Y      | Earnings Per Share (1y Forecast)       | e(?:arnings)*\s*p(?:er)*\s*s(?:hare)(?:\snext\sy(?:ea)?r)
Insider Trans   | Insider Transactions (Change in Owner) | insider\s*(?:transaction|txn)
Shares Float    | Shares Float (Open Market)             | sh(?:are)*s\s*flo?a?t
Short Ratio.    | Short Ratio (Percent Shares Short)     | sh(?:or)*t\s*(?:ratio|p(?:er)c(?:en)t)
Income          | Income (trailing 1 year)               | inco?me?
Sales           | Revenue                                | sales|rev(?:enue)
Dividend        | Dividend $ per annum                   | div(?:idend)*
Dividend %      | Dividend % per annum                   | div(?:idend)*\s(?:\%|pe?r?c(?:ent)*(?:age)*)
Employees       | Number of Worker Drones.               | (?:emp(?:loyees?)|worker(?:\s*drone)s|slaves|peons|drones)
Optionable      | Optionability (calls/puts)             | option(?:able)*
Shortable       | Shortable                              | short(?:able)*
Recom           | Analyst Ratings 1 (buy) - 5 (sell)     | analyst|(?:analyst\s+)*recomm?(?:end)*(?:ed|ation)*

