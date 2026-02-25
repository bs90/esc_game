class ImagesController < ApplicationController
  # Proxy endpoint to serve Google Drive images
  # This bypasses Google Drive's hotlinking restrictions
  def proxy
    file_id = params[:id]

    if file_id.blank?
      head :bad_request
      return
    end

    begin
      # Try multiple Google Drive URL formats
      image_urls = [
        "https://drive.google.com/uc?export=view&id=#{file_id}",
        "https://drive.google.com/uc?export=download&id=#{file_id}",
        "https://lh3.googleusercontent.com/d/#{file_id}=w1000"
      ]

      require 'net/http'
      require 'uri'

      image_urls.each do |image_url|
        uri = URI(image_url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.read_timeout = 10
        http.open_timeout = 10

        request = Net::HTTP::Get.new(uri.request_uri)
        # Add user agent to avoid blocking
        request['User-Agent'] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'

        response = http.request(request)

        if response.code == '200' && response.body.present?
          # Set appropriate headers
          content_type = response.content_type || 'image/jpeg'
          send_data response.body,
                    type: content_type,
                    disposition: 'inline'
          return
        end
      end

      # If all URLs fail, return 404
      head :not_found
    rescue => e
      Rails.logger.error "Error proxying Google Drive image: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      head :internal_server_error
    end
  end
end

