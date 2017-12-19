require 'cgi'

class SisterMercy::Commands::Img < SisterMercy::Command
  def self.name; :img; end


  def execute(event, *token)
    url = "http://api.giphy.com/v1/gifs/search?api_key=dc6zaTOxFJmzC&q=#{token * ?+}"
    begin
      data = get_json_from(url).data
      image = data[(rand * data.length).to_i].images.fixed_width.url
      return "I couldn't find anything..." unless image && image.length > 0
      image
    rescue
      "I think I got confused ;_;"
    end
  end
end
