require 'cgi'

class SisterMercy::Commands::Img < SisterMercy::Command
  def self.name; :img; end


  def execute(event, *token)
    url = "http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag={CGI.escape token*' '}"
    begin
      data = get_json_from url
      image = data.image_url
      return "I couldn't find anything..." unless image && image.length > 0
      image
    rescue
      "I think I got confused ;_;"
    end
  end
end
