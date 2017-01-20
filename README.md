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

### Custom response

    $ docker run -d -p 80:80 \
      -e 'status=201' \
      -e 'header_Content-Type=text/html' \
      -e 'header_X-Page-Type=mypage' \
      -e 'body=<h1>my page</h1>' \
      campanda/webserver-mock

__Note:__ All environment variables are optional. If any of them is omitted,
the corresponding default value is assumed.

The response of this server will be:

    $ curl -i http://localhost/
    HTTP/1.1 201 Created
    Content-Type: text/html
    X-Page-Type: mypage
    Server: WEBrick/1.3.1 (Ruby/2.4.0/2016-12-24)
    Date: Wed, 18 Jan 2017 21:53:32 GMT
    Content-Length: 16
    Connection: Keep-Alive

    <h1>my page</h1>

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
