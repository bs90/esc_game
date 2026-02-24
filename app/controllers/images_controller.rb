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
      # Fetch image from Google Drive
      image_url = "https://drive.google.com/uc?export=download&id=#{file_id}"

      # Use Net::HTTP to fetch the image
      require 'net/http'
      require 'uri'

      uri = URI(image_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)

      if response.code == '200'
        # Set appropriate headers
        send_data response.body,
                  type: response.content_type || 'image/jpeg',
                  disposition: 'inline'
      else
        # Try alternative format
        image_url = "https://drive.google.com/uc?export=view&id=#{file_id}"
        uri = URI(image_url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request)

        if response.code == '200'
          send_data response.body,
                    type: response.content_type || 'image/jpeg',
                    disposition: 'inline'
        else
          head :not_found
        end
      end
    rescue => e
      Rails.logger.error "Error proxying Google Drive image: #{e.message}"
      head :internal_server_error
    end
  end
end

