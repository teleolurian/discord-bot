require 'uri'
class SisterMercy::Commands::GoogleTranslate < SisterMercy::Command
  def self.name; :tr; end

  def description
    'Google Translate'
  end

  def execute(event, *args)
    text = URI.encode args.join(' ')
    response = get_json_from("https://www.googleapis.com/language/translate/v2?q=#{text}&target=en&key=#{GOOGLE_API_KEY}")
    +response.data.translations.first.translatedText rescue '*Could not find translation*'
  end
end
