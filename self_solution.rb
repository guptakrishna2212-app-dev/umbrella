p "Will you need an umbrella today?"

p "Where are you?"

user_location = gets.chomp

gmaps_key = ENV.fetch("GMAPS_KEY")

require "open-uri"
require "json"

raw_Json = URI.open("https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=#{gmaps_key}").read

better_Json = JSON.parse(raw_Json)

results = better_Json["results"]

results_geometry= results[0].fetch("geometry")

results_geometry_location = results_geometry["location"]


latitude = results_geometry_location["lat"]
longitude = results_geometry_location["lng"]

pirateweather_key = ENV.fetch("PIRATE_WEATHER_KEY")

raw_json_weather = URI.open("https://api.pirateweather.net/forecast/#{pirateweather_key}/#{latitude},#{longitude}").read

better_json_weather =  JSON.parse(raw_json_weather)

p "The current temperature is #{better_json_weather["currently"].fetch("temperature")} F"


p "The next hour is: #{better_json_weather["minutely"].fetch("summary")}"


repeat_array = better_json_weather["hourly"].fetch("data")
array = Array.new

repeat_array.each_with_index do |each_hour, each_index|
  array.push(repeat_array[each_index]["precipProbability"])
end

array = array[0..11]

rain_array = Array.new
array.each_with_index do |element, each_index|
  if element>0.1
    rain_array.push(element)
  end
end

require "date"

if !rain_array.empty?
  p "Rain expected soon, carry an umbrella"
else
  p "No rain expected in next 12 hours"
end
