module ApplicationHelper
  # Convert Google Drive URL to proxy URL for image display
  def google_drive_image_url(url)
    return url unless url.present?
    return url unless url.include?("drive.google.com") || url.include?("docs.google.com")

    # Extract file ID from Google Drive URL
    file_id = extract_google_drive_file_id(url)

    if file_id
      # Use proxy endpoint to serve the image
      image_proxy_path(id: file_id)
    else
      url
    end
  end

  private

  def extract_google_drive_file_id(url)
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
