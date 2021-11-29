# frozen_string_literal: true

class ApplicationController < ActionController::Base
  layout "doorkeeper/application"

  after_action :set_headers

  def generate_204
    head(:no_content)
  end

  def set_headers
    headers["Access-Control-Allow-Origin"] = "*"
    headers["Access-Control-Request-Method"] = %w{GET POST OPTIONS}.join(",")

    # possible X-Frame-Options: https://developer.mozilla.org/de/docs/Web/HTTP/Headers/X-Frame-Options
    # Rails sets "sameorigin" as default, so we need to remove that in order to allow all
    headers.delete "X-Frame-Options"
  end

end
