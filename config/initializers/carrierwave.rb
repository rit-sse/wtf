
if Rails.env.test? or 
  Rails.env.cucumber? or 
  Rails.env.development?

  puts "Mocking S3 Image Storage"
  Fog.mock!
end

Fog.credentials_path = Rails.root.join('config/fog_credentials.yml')

CarrierWave.configure do |config|
  config.storage = :fog
  config.fog_credentials = {:provider => 'AWS'}
  config.fog_directory = "images" # required
end

if Rails.env.test? or 
  Rails.env.cucumber? or 
  Rails.env.development?

  puts "Setting up fake S3 connection"
  connection = Fog::Storage.new(:provider => 'AWS')
  connection.directories.create(:key => 'images')
end
