require 'uri'
class SisterMercy::Commands::Czech < SisterMercy::Command
  def self.name; :cz; end

  def description
    'This translates into czech speak'
  end

  def execute(event, *args)
    text = URI.encode args.join(' ').gsub(/^\s+|\s+$/,'')
    response = get_json_from("https://www.googleapis.com/language/translate/v2?q=#{text}&target=cz&key=#{GOOGLE_API_KEY}")
    +response.data.translations.first.translatedText rescue '*something in czech*'
  end
end
