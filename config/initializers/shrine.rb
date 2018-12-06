require "shrine"

Shrine.plugin :sequel

require "shrine/storage/s3"
require "shrine/storage/file_system"
require "shrine/storage/ftp"

s3_options = {
  access_key_id:     ENV["AWS_ACCESS_KEY_ID"],
  secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
  region:            ENV["AWS_REGION"],
  bucket:            ENV["AWS_BUCKET_NAME"]
}

hmrc_ftp_options = {
  host: ENV["HMRC_FTP_HOST"],
  user: ENV["HMRC_FTP_USERNAME"],
  password: ENV["HMRC_FTP_PASSWORD"],
  dir: "/mnt/ftps"
}

# The shrine-ftp gem doesn't implement a method to set the FTP port, so
# need to use the underlying Net::FTP library's workaround instead. A better
# long-term option would be to fork/PR the gem
#
Net::FTP.const_set("FTP_PORT", ENV["HMRC_FTP_PORT"])

Shrine.storages = {
  s3_cache: Shrine::Storage::S3.new(prefix: "cache", upload_options: {acl: "private"}, **s3_options),
  s3_store: Shrine::Storage::S3.new(prefix: "store", upload_options: {acl: "private"}, **s3_options),
  hmrc_ftp: Shrine::Storage::Ftp.new(hmrc_ftp_options),
  disk_cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"), # temporary
  disk_store: Shrine::Storage::FileSystem.new("public", prefix: "uploads/store"), # permanent
}
