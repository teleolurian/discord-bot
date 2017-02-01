require 'cgi'

class SisterMercy::Commands::Img < SisterMercy::Command
  def self.name; :img; end


  def execute(event, *token)
    url = "https://commons.wikimedia.org/w/api.php?action=query&format=json&prop=images&list=search&srnamespace=6&srsearch=%22#{CGI.escape token*' '}%22"
    begin
      data = get_json_from url
      images = data.query.search
      return "I couldn't find anything..." unless images && images.length > 0
      h = hpricot("https://tools.wmflabs.org/magnus-toolserver/commonsapi.php?thumbwidth=800&image=" + CGI.escape(images.random.title))
      (h / 'file urls thumbnail').text
    rescue
      "I think I got confused ;_;"
    end
  end
end
