class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :file

  def store_dir
    "photos/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  
  def default_url
    "/images/fallback/photos/" + [version_name, "default.png"].compact.join('_')
  end

  process :resize_to_limit => [950, nil]
  #  process :resize_to_fit => [width, height]

  version :thumb do
    process :resize_to_limit => [170, nil]
  end

  #TODO Donot generate this ever pic.Just when use it.
  version :cover do
    process :resize_to_fill => [170, 170]
  end

  #Show in home_page index
  version :square do
    process :resize_to_fill => [115, 115]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
