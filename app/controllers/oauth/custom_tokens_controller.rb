class Oauth::CustomTokensController < Doorkeeper::TokensController

  include AbstractController::Callbacks
  before_action :cors_preflight_check
  after_action :set_headers

  def cors_preflight_check
    if request.method == :options
      puts "headers set for preflight"
      headers["Access-Control-Allow-Origin"] = "*"
      headers["Access-Control-Allow-Methods"] = "POST, PUT, GET, OPTIONS"
      headers["Access-Control-Allow-Headers"] = "Origin, X-Requested-With, Content-Type, Accept, Authorization"
      headers["Access-Control-Max-Age"] = "1728000"
      render :text => "", :content_type => "text/plain"
    end
  end

  def set_headers
    puts "headers set"
    headers["Access-Control-Allow-Origin"] = "*"
    headers["Access-Control-Allow-Methods"] = "GET, POST, PATCH, PUT, DELETE, OPTIONS, HEAD"
    headers["Access-Control-Allow-Headers"] = "Origin, X-Requested-With, Content-Type, Accept, Authorization"
    # headers['Access-Control-Allow-Headers'] = "*,X-Requested-With,Content-Type,If-Modified-Since,If-None-Match"
    # headers['Access-Control-Max-Age'] = "86400"

    # possible X-Frame-Options: https://developer.mozilla.org/de/docs/Web/HTTP/Headers/X-Frame-Options
    # Rails sets "sameorigin" as default, so we need to remove that in order to allow all
    headers.delete "X-Frame-Options"
  end
end
