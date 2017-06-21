$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'sinatra'
require 'SlackBot'
require 'net/http'

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
  def help(params, option = {})
    user_name = params[:user_name] ? "@#{params[:user_name]}" : ""
    return {text:"#{user_name}\n1. type say [ooo]\n2. type convert <number> <currency ; JPY> to <currency ; USD>\n"}.merge(option).to_json 
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

  unless config["slack_verification_token"] == params[:token]
    halt 403, "Invalid Slack verification token received: #{params[:token]}"
  end

  if /say/ =~ params[:text]
  	slackbot.delete_say(params, username: "Dbot")
  elsif /convert/ =~ params[:text]
  	slackbot.convert_currency(params, username: "Dbot")
  elsif /help/ =~ params[:text]
    slackbot.help(params, username: "Dbot")
  else
    slackbot.naive_respond(params, username: "Dbot")
  end
end
