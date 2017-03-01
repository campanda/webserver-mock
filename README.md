# webserver-mock

[![Build Status](https://travis-ci.org/campanda/webserver-mock.svg?branch=master)](https://travis-ci.org/campanda/webserver-mock)
[![Code Climate](https://codeclimate.com/github/campanda/webserver-mock/badges/gpa.svg)](https://codeclimate.com/github/campanda/webserver-mock)

Customizable HTTP/HTTPS webserver to be used as mock for service upstreams.

## Usage

### Default configuration

    $ docker run -d -p 80:80 campanda/webserver-mock
    // or you can with -it instead to check the logs

By default, it acts like an __echo server__:

    $ curl -i http://localhost/
    HTTP/1.1 200 OK
    Server: WEBrick/1.3.1 (Ruby/2.4.0/2016-12-24)
    Date: Wed, 18 Jan 2017 21:50:32 GMT
    Content-Length: 70
    Connection: Keep-Alive

    GET / HTTP/1.1

    Host: localhost
    User-Agent: curl/7.49.1
    Accept: */*

### Custom responses

You can specify one or more paths that will provide a custom response,
by defining them on a `YAML` file:

`/my-host-path/config.yml`:

    ---
    - path: '/some/custom/page'
      status: 200
      headers:
        'Content-Type': 'text/html'
        'X-Page-Type': 'mypage'
      body: '/my-mounted-path/mypage.html'

    - path: '/users/123.json'
      status: 200
      headers:
        'Content-Type': 'application/json'
      body: '/my-mounted-path/user-123.json'


And files with the body to be served for each custom response:

`/my-host-path/mypage.html`:

    <html>
    <body>
        <h1>My Page</h1>
    </body>
    </html>

`/my-host-path/user-123.json`:

    {
        "id": "123",
        "name": "a user"
    }

You just need to mount a volume with the custom response files and
inform where is the `custom_responses_config` YAML file:

    $ docker run -d -p 80:80 \
      -v '/my-host-path:/my-mounted-path' \
      -e 'custom_responses_config=/my-mounted-path/config.yml \
      campanda/webserver-mock

The response of this server will be:

    $ curl -i http://localhost/users/123.json
    HTTP/1.1 200 OK
    Content-Type: application/json
    Server: WEBrick/1.3.1 (Ruby/2.4.0/2016-12-24)
    Date: Wed, 18 Jan 2017 21:53:32 GMT
    Content-Length: 31
    Connection: Keep-Alive

    {"id": "123", "name": "a user"}

__Note:__ All environment variables are optional. If any of them is omitted,
the corresponding default value is assumed.

### HTTPS

    $ docker run -d -p 443:443 -e 'ssl=true' campanda/webserver-mock
    // or you can with -it instead to check the logs

__Note #1:__ `status`, `header_` and `body` environment variables can be defined
in this case also.

__Note #2:__ It uses an invalid (self-signed) certificate, since it is only meant
for testing purposes.

    $ curl -ik https://localhost/
    HTTP/1.1 200 OK
    Server: WEBrick/1.3.1 (Ruby/2.4.0/2016-12-24) OpenSSL/1.0.2j
    Date: Wed, 18 Jan 2017 22:02:47 GMT
    Content-Length: 70
    Connection: Keep-Alive

    GET / HTTP/1.1

    Host: localhost
    User-Agent: curl/7.49.1
    Accept: */*

### Predefined responses

The webserver comes with some predefined response status codes for certain paths:

| Path                    | Response code |
| :---                    |          ---: |
| /bad-request            | 400           |
| /unauthorized           | 401           |
| /forbidden              | 403           |
| /not-found              | 404           |
| /internal-server-error  | 500           |
| /bad-gateway            | 502           |
| /service-unavailable    | 503           |
| /gateway-timeout        | 504           |

### Custom HTTP verbs

    $ docker run -d -p 80:80 -e 'allow_http_verbs=FOO,BAR' campanda/webserver-mock
    // or you can with -it instead to check the logs

By default only `GET` and `POST` are allowed.

    $ curl -i http://localhost/ -X FOO
    HTTP/1.1 200 OK
    ...

    $ curl -i http://localhost/ -X BAR
    HTTP/1.1 200 OK
    ...

    $ curl -i http://localhost/ -X BACON
    HTTP/1.1 405 Method Not Allowed
    ...

## License

webserver-mock is released under the [MIT License][0].

[0]: http://www.opensource.org/licenses/MIT
