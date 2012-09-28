class AvatarUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
#  storage :file
  # storage :fog
  storage :upyun
  
  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "photos/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    pic_type = "jpg"
    if version_name == :bigpic
      pic_type = "gif"
    end
    "#{YUN_IMAGES}fallback/" + [version_name, "default." + pic_type].compact.join('_')
  end

  #Maybe means max width is 800 and max height is 1000
  #process :resize_to_fit => [800, 1000]
  #Maybe means max width is 800 and height is not limited
  process :resize_to_limit => [600, 600]
  # Process files as they are uploaded:
  #process :scale => [800, 800]

  # Create different versions of your uploaded files:
  version :thumb do
   process :resize_to_fill => [48, 48]
  end

  version :bigpic do
   process :resize_to_fill => [180, 180]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # Need not write pNg etc .Then are OK for here has png.
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
