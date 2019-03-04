require 'uri'

class SisterMercy::Commands::Gif < SisterMercy::Command
  def self.name; :gif ; end


  def execute(event, *imagesearch)
    imagesearch ||= %w{ wtf }
    url = "http://www.tenor.com/search/" + URI.encode(imagesearch.join(?-)
    begin
      h = hpricot(url)
      (h / '#view .gallery-container .GifList .GifListItem a').random['href']
    rescue
      "I... I'll try harder next time..."
    end
  end
end
