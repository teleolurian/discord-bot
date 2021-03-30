require 'uri'
class SisterMercy::Commands::Arabize < SisterMercy::Command
  def self.name; :ar; end

  def description
    'This translates into arab speak'
  end

  def execute(event, *args)
    text = URI.encode args.join(' ').gsub(/^\s+|\s+$/,'')
    response = get_json_from("https://www.googleapis.com/language/translate/v2?q=#{text}&target=ar&key=#{GOOGLE_API_KEY}")
    +response.data.translations.first.translatedText rescue '*allahu akbar*'
  end
end
