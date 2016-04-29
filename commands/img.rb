class SisterMercy::Commands::Img < SisterMercy::Command
  def self.name; :img; end

  def execute(event, subreddit=nil)
    url = "http://imgur.com" + subreddit ? "/r/#{subreddit}" : ''
    begin
      h = hpricot(url)
      'http:' + (h / 'img').random['src'].sub(/b\.$/, '.')
    rescue
      "I'm sooo sorry! I can't get that right now ;_;"
    end
  end
end
