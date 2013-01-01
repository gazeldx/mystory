class BaseUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage Settings[:upyun] ? :upyun : :file
  
  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
