def add_headers(res, headers)
  headers.each_pair { |key, val| res[key] = val }
  res
end

def echo(req)
  body = "#{req.request_line}\n"
  req.raw_header.each { |header| body += "#{header.strip}\n" }
  body += "\n#{req.body}"
  body
end

require 'webrick'

if ENV['allow_http_verbs']
  module WEBrick
    module HTTPServlet
      # Allowing server to respond to requests using custom HTTP verbs
      class ProcHandler
        ENV['allow_http_verbs'].split(',').each do |verb|
          alias_method "do_#{verb}", 'do_GET'
        end
      end
    end
  end
end

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

if ENV['custom_responses_config']
  require 'yaml'
  custom_responses_config = YAML::load_file(ENV['custom_responses_config'])
  custom_responses_config.each do |custom_response|

    server.mount_proc custom_response['path'] do |req, res|
      res = add_headers(res, custom_response['headers']) if custom_response['headers']
      res.status = custom_response['status'] || 200
      res.body = custom_response['body'] ? File.read(custom_response['body']) : echo(req)
    end

  end
else

  # fallback to echo server
  server.mount_proc '/' do |req, res|
    res.status = 200
    res.body = echo(req)
  end

end

server.start
