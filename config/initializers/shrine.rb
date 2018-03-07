require "shrine"

Shrine.plugin :sequel

if Rails.env.production?
  require "shrine/storage/s3"
  require "shrine/storage/file_system"
  require "shrine/storage/scp"

  s3_options = {
    access_key_id:     ENV["AWS_ACCESS_KEY_ID"],
    secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
    region:            ENV["AWS_REGION"],
    bucket:            ENV["AWS_BUCKET_NAME"]
  }

  # expects ssh keys
  scp_options = {
    ssh_host: ENV["SCP_HOST"],
    options: "-i #{Rails.root}/ssh/id_rsa",
    directory: "/taric3"
  }

  Shrine.storages = {
    cache: Shrine::Storage::S3.new(prefix: "cache", **s3_options),
    store: Shrine::Storage::S3.new(prefix: "store", **s3_options),
    scp_store: Shrine::Storage::Scp.new(scp_options)
  }
else
  require "shrine/storage/file_system"

  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"), # temporary
    store: Shrine::Storage::FileSystem.new("public", prefix: "uploads/store"), # permanent
  }
end
