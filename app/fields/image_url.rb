require "administrate/field/base"

module Administrate
  module Field
    class ImageUrl < Base
      def to_s
        data
      end

      # Convert Google Drive URL to direct image link
      # Uses proxy endpoint to bypass Google Drive hotlinking restrictions
      def image_url
        return data unless data.present?

        # Check if it's a Google Drive URL
        if data.include?("drive.google.com") || data.include?("docs.google.com")
          # Extract file ID from various Google Drive URL formats
          file_id = google_drive_file_id

          if file_id
            # Use proxy endpoint to serve the image
            # This bypasses Google Drive's hotlinking restrictions
            Rails.application.routes.url_helpers.image_proxy_path(id: file_id)
          else
            data
          end
        else
          data
        end
      end

      # Get Google Drive file ID if URL is a Google Drive link
      def google_drive_file_id
        return nil unless data.present?
        return nil unless data.include?("drive.google.com") || data.include?("docs.google.com")

        extract_google_drive_file_id(data)
      end

      private

      def extract_google_drive_file_id(url)
        # Match various Google Drive URL formats:
        # https://drive.google.com/file/d/FILE_ID/view
        # https://drive.google.com/file/d/FILE_ID/edit
        # https://drive.google.com/open?id=FILE_ID
        # https://docs.google.com/uc?export=download&id=FILE_ID

        patterns = [
          %r{/file/d/([a-zA-Z0-9_-]+)},
          %r{[?&]id=([a-zA-Z0-9_-]+)},
          %r{/open\?id=([a-zA-Z0-9_-]+)}
        ]

        patterns.each do |pattern|
          match = url.match(pattern)
          return match[1] if match
        end

        nil
      end
    end
  end
end

