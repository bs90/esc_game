# Load custom Administrate field types
# These files are manually required because they use Administrate::Field namespace
# which doesn't match Zeitwerk's expected file structure
Rails.application.config.to_prepare do
  Dir[Rails.root.join("app", "fields", "*.rb")].each do |file|
    require file
  end
end

