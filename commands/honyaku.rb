require 'uri'
class SisterMercy::Commands::Honyaku < SisterMercy::Command
  def self.name; :jp; end

  def description
    '英語から日本語まで翻訳してみます'
  end

  def execute(event, *args)
    text = URI.encode args.join(' ').gsub(/^\s+|\s+$/,'')
    response = get_json_from("https://www.googleapis.com/language/translate/v2?q=#{text}&target=ja&key=#{GOOGLE_API_KEY}")
    +response.data.translations.first.translatedText rescue '*翻訳が出来なくてすみません*'
  end
end
