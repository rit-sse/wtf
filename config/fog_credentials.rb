
# Copy this file into ROOT/config/s3_credentials.rb
# And change the lines indicated with CHANGE

# First have to create and make an images- directory
#  if it doesn't already exist.
storage = Fog::Storage.new({
  :provider => 'AWS', 
  :aws_access_key_id => 'XXX', # CHANGE
  :aws_secret_access_key => 'YYY' # CHANGE
})

hasImages = storage.directories.any? {|dir| dir.key.starts_with? "images-"}
hasImages or storage.directories.create(
  :key => "images-#{Time.now.to_i}",
  :public => true
)
imageDirs= storage.directories.select {|dir| dir.key.starts_with? "images-"}
puts "Using bucket #{imageDirs.first.key}"

# Now that we have it, configure CarrierWave
CarrierWave.configure do |config|
  config.storage = :fog
  config.fog_credentials = {
    :provider => 'AWS',
    :aws_access_key_id => 'XXX', # CHANGE
    :aws_secret_access_key => 'YYY', # CHANGE
    :region => 'us-east-1'
  }
  config.fog_directory = imageDirs.first.key
end

