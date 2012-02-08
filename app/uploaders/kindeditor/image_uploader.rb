# encoding: utf-8

class Kindeditor::ImageUploader < Kindeditor::AssetUploader

  def extension_white_list
    EXT_NAMES[:image]
  end

  #  def store_dir
  #    "#{BASE_DIR}/#{session[:id]}/#{controller_path}/#{Time.now.strftime("%Y%m")}"
  #  end

  def store_dir
    f = self.class.to_s.underscore.gsub(/(kindeditor\/)|(_uploader)/, '')
    if f != 'image'
      f = 'thumb'
    end
    "#{BASE_DIR}/#{f}/#{Time.now.strftime("%Y%m")}"
  end

  version :thumb do
    process :resize_to_limit => [160, 160]
  end

  process :resize_to_limit => [600, nil]

end