require 'rails_helper'

shared_context 'taric3 xsd context' do

  context 'database export' do

    let(:xml_export_file) do
      create(:xml_export_file, :database)
    end

    it 'should generate valid xml' do
      db_record
      taric_export = ::XmlGeneration::TaricExport.new(xml_export_file)
      taric_export.run
      expect(taric_export.xml_data).to pass_validation('lib/xml_generation_system_files/taric3_public_schema.xsd')
    end

  end

  context 'workbasket export' do

    let(:xml_export_file) do
      create(:xml_export_file, :workbasket)
    end

    let!(:workbasket) do
      create(
          :workbasket,
          :create_measures,
          operation_date: Date.today
      )
    end

    before(:each) do
      workbasket

      db_record.workbasket_id = workbasket.id
      db_record.workbasket_sequence_number = 1
      db_record.status = "awaiting_cross_check"
      db_record.save

      db_record.reload
      workbasket.reload

      allow_any_instance_of(Workbaskets::CreateMeasuresSettings).to receive(:collection) { [db_record] }
    end

    it 'should generate valid xml' do
      taric_export = ::XmlGeneration::TaricExport.new(xml_export_file)
      taric_export.run
      expect(taric_export.xml_data).to pass_validation('lib/xml_generation_system_files/taric3_public_schema.xsd')
    end
  end

end
