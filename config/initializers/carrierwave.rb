
if FileTest.exists?(Rails.root.join('config/s3_credentials.yml'))

  puts "Using real credentials"
  Fog.credentials_path = Rails.root.join('config/s3_credentials.yml')

  CarrierWave.configure do |config|
    config.storage = :fog
    config.fog_credentials = {:provider => 'AWS'}
    config.fog_directory = "images" # required
  end
elsif Rails.env.test? or 
  Rails.env.cucumber? or 
  Rails.env.development?

  puts "Using filesystem for uploads"
  CarrierWave.configure do |config|
    config.storage = :file
  end

  # puts "Mocking S3 Image Storage"
  # Fog.mock!
  # puts "Setting up fake S3 connection"
  # connection = Fog::Storage.new(:provider => 'AWS')
  # connection.directories.create(:key => 'images')
else
  puts "Error!  No method to store files configured."
end
