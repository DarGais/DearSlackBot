require 'net/https'
require 'uri'
require 'json'

def post_json(url, params)
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)

  request = Net::HTTP::Post.new(uri.path)
  request.set_form_data(params)
  res = http.request(request)

  return res
end

params = JSON.parse(File.read(ARGV[1]).chomp)
p post_json(ARGV[0], params).body
