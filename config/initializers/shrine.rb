require "shrine"

Shrine.plugin :sequel

if Rails.env.production?
  require "shrine/storage/s3"
  require "shrine/storage/file_system"
  require "shrine-ftp"

  s3_options = {
    access_key_id:     ENV["AWS_ACCESS_KEY_ID"],
    secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
    region:            ENV["AWS_REGION"],
    bucket:            ENV["AWS_BUCKET_NAME"]
  }

  ftp_options = {
    host: ENV["FTP_HOST"],
    user: ENV["FTP_USERNAME"],
    passwd: ENV["FTP_PASSWORD"],
    dir: "taric3"
  }

  Shrine.storages = {
    cache: Shrine::Storage::S3.new(prefix: "cache", **s3_options),
    store: Shrine::Storage::S3.new(prefix: "store", **s3_options),
    ftp_store: Shrine::Storage::Ftp.new(ftp_options)
  }
else
  require "shrine/storage/file_system"

  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"), # temporary
    store: Shrine::Storage::FileSystem.new("public", prefix: "uploads/store"), # permanent
  }
end
