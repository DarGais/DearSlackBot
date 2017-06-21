require 'json'
require 'uri'
require 'yaml'
require 'net/https'

class SlackBot
  def initialize(settings_file_path = "settings.yml")
    config = YAML.load_file(settings_file_path) if File.exist?(settings_file_path)
    # This code assumes to set incoming webhook url as evironment variable in Heroku
    # SlackBot uses settings.yml as config when it serves on local
    puts  ENV['INCOMING_WEBHOOK_URL']
    @incoming_webhook = ENV['INCOMING_WEBHOOK_URL'] || config["incoming_webhook_url"]

  end

  def post_message(string, options = {})
    payload = options.merge({text: string})
    uri = URI.parse(@incoming_webhook)
    res = nil
    request = "payload=" + json

    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      res = http.post(uri.request_uri, request)
    end

    return res
  end

  def naive_respond(params, options = {})
    return nil if params[:user_name] == "slackbot" || params[:user_id] == "USLACKBOT"

    user_name = params[:user_name] ? "@#{params[:user_name]}" : ""
    return {text: "#{user_name} Hi! Try 'help' for instruction}.merge(options).to_json
  end
end
