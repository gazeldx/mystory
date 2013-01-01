class BgimageUploader < BaseUploader
  include CarrierWave::MiniMagick
  storage Settings[:upyun] ? :upyun : :file

  def store_dir
    "photos/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  
  process :resize_to_limit => [1200, nil]

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
