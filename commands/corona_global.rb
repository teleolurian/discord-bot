require 'open-uri'
require 'time'
require 'csv'
class SisterMercy::Commands::CoronaGlobal < SisterMercy::Command
  def self.name; :corona; end

  def description
    'Per Country Coronavirus'
  end

  def execute(event, *args)
    location = args.join ?-
    begin
      if location.length == 2 #state
        response = JSON.parse get_raw_json_from "https://api.covidtracking.com/v1/states/#{location.downcase}/daily.json"
        result = response[0..20].map do |x|
          "#{x['dateChecked']} - #{x['totalTestResults']} tested / #{x['positiveCasesViral'] || x['totalTestsViral']} pozzed / #{x['death']} dead"
        end
        +result.join($/)
      else
        response = JSON.parse(get_raw_json_from("https://api.covid19api.com/country/#{location.downcase}/status/confirmed"))
        result = response[-10..-1].map do |x|
            date = Time.parse(x['Date']).strftime "%Y %b %e"
            "#{date} - #{x['Country']} #{x['Province']} #{x['Cases']} cases"
        end
        +result.join($/)
      end
    end
  rescue Exception => e
    +"Can't parse location #{location}. Please use a country name or state abbreviation. Error #{e}"
  end
end
