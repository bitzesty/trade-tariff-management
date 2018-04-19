Sequel.migration do
  change do
    sql = <<-eos
      SELECT
        base_regulation_id as id,
        base_regulation_role as role,
        information_text,
        validity_start_date,
        validity_end_date,
        replacement_indicator
      from base_regulations_oplog
      UNION
      SELECT
        modification_regulation_id as id,
        modification_regulation_role as role,
        information_text,
        validity_start_date,
        validity_end_date,
        replacement_indicator
      from modification_regulations_oplog
      UNION
      SELECT
        complete_abrogation_regulation_id as id,
        complete_abrogation_regulation_role as role,
        information_text,
        published_date as validity_start_date,
        TIMESTAMP 'infinity' as validity_end_date,
        replacement_indicator
      from complete_abrogation_regulations_oplog
      UNION
      SELECT
        explicit_abrogation_regulation_id as id,
        explicit_abrogation_regulation_role as role,
        information_text,
        published_date as validity_start_date,
        TIMESTAMP 'infinity' as validity_end_date,
        replacement_indicator
      from explicit_abrogation_regulations_oplog
      UNION
      SELECT
        prorogation_regulation_id as id,
        prorogation_regulation_role as role,
        information_text,
        published_date as validity_start_date,
        TIMESTAMP 'infinity' as validity_end_date,
        replacement_indicator
      from prorogation_regulations_oplog
eos

    create_view :regulations_lookup, sql
  end
end
