Sequel.migration do
  up do
    %w(
      measure_types_oplog
      measure_type_descriptions_oplog
    ).map do |table_name|
      add_column table_name, :added_by_id, Integer
      add_column table_name, :added_at, Time
    end

    run %Q{
      CREATE OR REPLACE VIEW public.measure_types AS
       SELECT measure_types1.measure_type_id,
          measure_types1.validity_start_date,
          measure_types1.validity_end_date,
          measure_types1.trade_movement_code,
          measure_types1.priority_code,
          measure_types1.measure_component_applicable_code,
          measure_types1.origin_dest_code,
          measure_types1.order_number_capture_code,
          measure_types1.measure_explosion_level,
          measure_types1.measure_type_series_id,
          measure_types1."national",
          measure_types1.measure_type_acronym,
          measure_types1.oid,
          measure_types1.operation,
          measure_types1.operation_date,
          measure_types1.status,
          measure_types1.workbasket_id,
          measure_types1.workbasket_sequence_number,
          measure_types1.added_by_id,
          measure_types1.added_at
         FROM public.measure_types_oplog measure_types1
        WHERE ((measure_types1.oid IN ( SELECT max(measure_types2.oid) AS max
                 FROM public.measure_types_oplog measure_types2
                WHERE ((measure_types1.measure_type_id)::text = (measure_types2.measure_type_id)::text))) AND ((measure_types1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE OR REPLACE VIEW public.measure_type_descriptions AS
       SELECT measure_type_descriptions1.measure_type_id,
          measure_type_descriptions1.language_id,
          measure_type_descriptions1.description,
          measure_type_descriptions1."national",
          measure_type_descriptions1.oid,
          measure_type_descriptions1.operation,
          measure_type_descriptions1.operation_date,
          measure_type_descriptions1.status,
          measure_type_descriptions1.workbasket_id,
          measure_type_descriptions1.workbasket_sequence_number,
          measure_type_descriptions1.added_by_id,
          measure_type_descriptions1.added_at
         FROM public.measure_type_descriptions_oplog measure_type_descriptions1
        WHERE ((measure_type_descriptions1.oid IN ( SELECT max(measure_type_descriptions2.oid) AS max
                 FROM public.measure_type_descriptions_oplog measure_type_descriptions2
                WHERE ((measure_type_descriptions1.measure_type_id)::text = (measure_type_descriptions2.measure_type_id)::text))) AND ((measure_type_descriptions1.operation)::text <> 'D'::text));
    }
  end

  down do
    run %Q{
      DROP VIEW public.measure_types;

      CREATE OR REPLACE VIEW public.measure_types AS
       SELECT measure_types1.measure_type_id,
          measure_types1.validity_start_date,
          measure_types1.validity_end_date,
          measure_types1.trade_movement_code,
          measure_types1.priority_code,
          measure_types1.measure_component_applicable_code,
          measure_types1.origin_dest_code,
          measure_types1.order_number_capture_code,
          measure_types1.measure_explosion_level,
          measure_types1.measure_type_series_id,
          measure_types1."national",
          measure_types1.measure_type_acronym,
          measure_types1.oid,
          measure_types1.operation,
          measure_types1.operation_date,
          measure_types1.status,
          measure_types1.workbasket_id,
          measure_types1.workbasket_sequence_number
         FROM public.measure_types_oplog measure_types1
        WHERE ((measure_types1.oid IN ( SELECT max(measure_types2.oid) AS max
                 FROM public.measure_types_oplog measure_types2
                WHERE ((measure_types1.measure_type_id)::text = (measure_types2.measure_type_id)::text))) AND ((measure_types1.operation)::text <> 'D'::text));
    }

    run %Q{
      DROP VIEW public.measure_type_descriptions;

      CREATE OR REPLACE VIEW public.measure_type_descriptions AS
       SELECT measure_type_descriptions1.measure_type_id,
          measure_type_descriptions1.language_id,
          measure_type_descriptions1.description,
          measure_type_descriptions1."national",
          measure_type_descriptions1.oid,
          measure_type_descriptions1.operation,
          measure_type_descriptions1.operation_date,
          measure_type_descriptions1.status,
          measure_type_descriptions1.workbasket_id,
          measure_type_descriptions1.workbasket_sequence_number
         FROM public.measure_type_descriptions_oplog measure_type_descriptions1
        WHERE ((measure_type_descriptions1.oid IN ( SELECT max(measure_type_descriptions2.oid) AS max
                 FROM public.measure_type_descriptions_oplog measure_type_descriptions2
                WHERE ((measure_type_descriptions1.measure_type_id)::text = (measure_type_descriptions2.measure_type_id)::text))) AND ((measure_type_descriptions1.operation)::text <> 'D'::text));
    }

    %w(
      measure_types_oplog
      measure_type_descriptions_oplog
    ).map do |table_name|
      drop_column table_name, :added_by_id
      drop_column table_name, :added_at
    end
  end
end
