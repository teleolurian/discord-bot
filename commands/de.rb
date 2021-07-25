require 'uri'
class SisterMercy::Commands::German < SisterMercy::Command
  def self.name; :de; end

  def description
    'This translates into ze motherland language'
  end

  def execute(event, *args)
    text = URI.encode args.join(' ').gsub(/^\s+|\s+$/,'')
    response = get_json_from("https://www.googleapis.com/language/translate/v2?q=#{text}&target=de&key=#{GOOGLE_API_KEY}")
    +response.data.translations.first.translatedText rescue '*was ist das? hell oder dunkel*'
  end
end
