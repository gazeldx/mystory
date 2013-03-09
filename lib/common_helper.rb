module CommonHelper
  def storage_type
    Settings[:upyun] ? :upyun : :file
  end
end

CarrierWave::Uploader::Base.send(:include, CommonHelper)