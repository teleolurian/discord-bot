require 'uri'
class SisterMercy::Commands::Francais < SisterMercy::Command
  def self.name; :fr; end

  def description
    'This translates into frog speak'
  end

  def execute(event, *args)
    text = URI.encode args.join(' ').gsub(/^\s+|\s+$/,'')
    response = get_json_from("https://www.googleapis.com/language/translate/v2?q=#{text}&target=fr&key=#{GOOGLE_API_KEY}")
    +response.data.translations.first.translatedText rescue '*je ne parlez*'
  end
end
