class SisterMercy::Commands::Img < SisterMercy::Command
  def self.name; :img; end

  def execute(event, subreddit=nil)
    url = "http://imgur.com" + (subreddit ? "/r/#{subreddit}" : '')
    begin
      h = hpricot(url)
      url2 = "http://imgur.com" + (h / 'a.image-list-link').random['href']
      h2 = hpricot(url2)
      item = (h2 / '.post-image source, .post-image img')
      "http:" + item.last['src']
    rescue
      "I'm sooo sorry! I can't get that right now ;_;"
    end
  end
end
