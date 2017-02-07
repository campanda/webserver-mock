def add_headers(res)
  headers = ENV.select { |key, _val| key.match(/^header_/) }
  headers.map { |key, val| res[key.sub(/^header_/, '')] = val }
  res
end

def echo(req)
  body = "#{req.request_line}\n"
  req.raw_header.each { |header| body += "#{header.strip}\n" }
  body += "\n#{req.body}"
  body
end

require 'webrick'

if ENV['ssl']
  require 'webrick/https'
  opts = { Port: 443, SSLEnable: true, SSLCertName: [%w(CN localhost)] }
else
  opts = { Port: 80 }
end

server = WEBrick::HTTPServer.new(opts)

predefined_responses = {
  400 => '/bad-request',
  401 => '/unauthorized',
  403 => '/forbidden',
  404 => '/not-found',
  500 => '/internal-server-error',
  502 => '/bad-gateway',
  503 => '/service-unavailable',
  504 => '/gateway-timeout'
}

predefined_responses.each_pair do |status, path|
  server.mount_proc path do |_req, res|
    res.status = status
  end
end

server.mount_proc '/' do |req, res|
  res = add_headers(res)
  res.status = ENV['status'] || 200
  res.body = echo(req)
  res.body += "\n#{ENV['body']}"
  res
end

server.start
