require 'uri'

class SisterMercy::Commands::JustRead < SisterMercy::Command
  def self.name; :justread; end


  def execute(event, *book)
<<<<<<< HEAD
    return "^_^" unless book
    book = book.join(' ')
    url = "http://www.whatshouldireadnext.com/index.php?q=" + URI.encode(book)
    begin
      h = hpricot(url)
      url2 = (h / 'ul.choice a').random['href']
      h2 = hpricot('http://www.whatshouldireadnext.com' + url2)
      items = (h2 / 'ul.booklist li.recommendation-logged-out').map(&:to_plain_text)
      puts items.inspect
      items[0..2].compact.map {|x| event << x}
      "More at http://www.whatshouldireadnext.com#{url2} !"
=======
  	return "^_^"
  	book = book.join(' ')
  	url = "http://www.whatshouldireadnext.com/index.php?q=" + URI.encode book
  	begin
		  h = hpricot(url)
      url2 = (h / 'ul.choice a').random['href']
      h2 = hpricot(url2)
      items = (h2 / 'ul.booklist ul.row li.recommendations ul.row').map(&:to_plain_text)
      items[0..2].compact.map {|x| event << x}
      "More at #{url2}!"
>>>>>>> 9d9f674... Just Read
    rescue
      "I... I'll try harder next time..."
    end
  end
end
