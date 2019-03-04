require 'uri'
class SisterMercy::Commands::Icelandic < SisterMercy::Command
  def self.name; :ice; end

  def description
    'This translates into ice speak'
  end

  def execute(event, *args)
    text = URI.encode args.join(' ').gsub(/^\s+|\s+$/,'')
    response = get_json_from("https://www.googleapis.com/language/translate/v2?q=#{text}&target=is&key=#{GOOGLE_API_KEY}")
    +response.data.translations.first.translatedText rescue '*Ég er ekki góður í þessu*'
  end
end
