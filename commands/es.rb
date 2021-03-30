require 'uri'
class SisterMercy::Commands::Spanish < SisterMercy::Command
  def self.name; :es; end

  def description
    'This translates into emu speak'
  end

  def execute(event, *args)
    text = URI.encode args.join(' ').gsub(/^\s+|\s+$/,'')
    response = get_json_from("https://www.googleapis.com/language/translate/v2?q=#{text}&target=es&key=#{GOOGLE_API_KEY}")
    +response.data.translations.first.translatedText rescue '*no comprende senor'
  end
end
