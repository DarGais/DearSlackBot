$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'sinatra'
require 'SlackBot'
require 'net/http'
require 'json'
require 'date'

class MySlackBot < SlackBot
  # cool code goes here
  def delete_say(params, option = {})
  	message = params[:text].gsub("@Dbot say [",'')
  	message = message.gsub("]",'')
  	user_name = params[:user_name] ? "@#{params[:user_name]}" : ""
  	return {text: "#{user_name} #{message}"}.merge(option).to_json
  end
  #---------------------------------------------------------------
  def convert_currency(params, option = {})
  	message = params[:text].gsub("@Dbot",'')
  	array = message.split #convert(0) 25(1) thb(2) to(3) jpy(4)
  	num = array[1].to_f
  	src = array[2].upcase
  	dest = array[4].upcase

  	data = Net::HTTP.get('www.google.com', "/finance/converter?a=#{num}&from=#{src}&to=#{dest}")
    user_name = params[:user_name] ? "@#{params[:user_name]}" : ""
    if /[\d.]+\s+#{dest}/ =~ data
      ans = $&
      message = "#{user_name} #{num} #{src} = #{ans}"
    else
      message = "ERROR, please check your spelling."
    end
    return {text: "#{message} \nsrc : www.google.com/finance/converter?a=#{num}&from=#{src}&to=#{dest}"}.merge(option).to_json
  end
  #----------------------------------------------------------------
  def get_sensor_value(params, option = {})
    user_name = params[:user_name] ? "@#{params[:user_name]}" : ""
    message = params[:text].gsub("@",'')#Dbot get room106 status [time]
    array = message.split                #  0   1    2        3
    if array[4] == nil
      t = "now"
    else
      t = array[4].gsub(".",':')
    end

    url = "https://eye-dear.herokuapp.com/channels/get_values?api_key=dear&time=#{t}"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)

    timestamp = DateTime.parse(data['timestamp'], '%Y-%m-%dT%H:%M:%S%z')

    date = timestamp.day.to_s + "/" + timestamp.month.to_s + "/" + timestamp.year.to_s
    if timestamp.minute < 10
      time = timestamp.hour.to_s + ":" + "0" + timestamp.minute.to_s
    else
      time = timestamp.hour.to_s + ":" + timestamp.minute.to_s
    end

    temp = data['value1']
    light = data['value2']
    if data['value3'] == 1.0 || data['value3'] == 1
      door = "lock"
    else
      door = "unlock"
    end
    message = "Date = #{date}\nTime = #{time}\nTemp. = #{temp} celcius\nLight = #{light}\nDoor status = #{door}\n"


    return {text: "#{user_name} #{message}"}.merge(option).to_json
  end
  #----------------------------------------------------------------
  def help(params, option = {})
    user_name = params[:user_name] ? "@#{params[:user_name]}" : ""
    return {text:"#{user_name}\n
    1. type \"say [ooo]\"\n
    2. type \"convert <number> <currency ; JPY> to <currency ; USD>\"\n
    3. type \"get room106 status\" or \"get room106 status @<time ; 9.00 or 9:00>\" \n"}.merge(option).to_json
  end
  #---------------------------------------------------------------
end

slackbot = MySlackBot.new

set :environment, :production

get '/' do
  "SlackBot Server"
end

post '/slack' do
  content_type :json

  if params[:token] == "jcXwOOzu4DRWGcIqoOhZf4iF"
    if /say/ =~ params[:text]
  	 slackbot.delete_say(params, username: "Dbot")
    elsif /convert/ =~ params[:text]
  	 slackbot.convert_currency(params, username: "Dbot")
    elsif /help/ =~ params[:text]
      slackbot.help(params, username: "Dbot")
    elsif /get room106 status/ =~ params[:text] || /get 106 status/ =~ params[:text]
      slackbot.get_sensor_value(params, username: "Dbot")
    else
      slackbot.naive_respond(params, username: "Dbot")
    end
  else
    puts "ERROR, wrong token/don't have token."
  end
end
