# Import Taric file manually. Usually for initial seed files.
namespace :importer do
  namespace :taric do
    desc "Import Tariff file"
    task import: %i[environment class_eager_load] do
      if ENV["TARGET"] && File.exist?(ENV["TARGET"])
        # We will be fetching updates from Taric and modifying primary keys
        # so unrestrict it for all models.
        Sequel::Model.subclasses.each(&:unrestrict_primary_key)
        Sequel::Model.plugin :skip_create_refresh
        dummy_update = OpenStruct.new(file_path: ENV["TARGET"], issue_date: nil)
        TaricImporter.new(dummy_update).import(validate: false)
      else
        puts "Please provide TARGET environment variable pointing to Tariff file to import"
      end
    end

    desc "Import Tariff file from S3 bucket"
    task imports3: %i[environment class_eager_load] do
      # s3 = Aws::S3::Resource.new.bucket(ENV["AWS_BUCKET_NAME"])
      # file = s3.object(ENV["TARGET"]).get.body.string
      # puts file
      # We will be fetching updates from Taric and modifying primary keys
      # so unrestrict it for all models.
      Sequel::Model.subclasses.each(&:unrestrict_primary_key)
      Sequel::Model.plugin :skip_create_refresh
      dummy_update = OpenStruct.new(file_path: ENV["TARGET"], issue_date: nil)
      TaricImporter.new(dummy_update).import(validate: false)
    end

  end
end
