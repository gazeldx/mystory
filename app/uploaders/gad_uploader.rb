class GadUploader < BaseUploader  
  def store_dir
    "photos/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  
  def default_url
    "#{YUN_IMAGES}fallback/photos/" + [version_name, "default.png"].compact.join('_')
  end

  # This is top ad
  process :resize_to_limit => [960, nil]

  version :side do
    process :resize_to_limit => [310, nil]
  end
end
