if FileTest.exists?(Rails.root.join('config/s3_credentials.rb'))

  puts "Using real credentials"

  credentials_path = Rails.root.join('config/s3_credentials.rb')
  require credentials_path

elsif !Rails.env.production?
  CarrierWave.configure do |config|
    config.storage = :file
  end

  # puts "Mocking S3 Image Storage"
  # Fog.mock!
  # puts "Setting up fake S3 connection"
  # connection = Fog::Storage.new(:provider => 'AWS')
  # connection.directories.create(:key => 'images')
else
  Rails.logger.error "No method to store files configured."
end
