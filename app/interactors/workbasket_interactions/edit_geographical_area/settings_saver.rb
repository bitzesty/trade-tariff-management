module WorkbasketInteractions
  module EditGeographicalArea
    class SettingsSaver
      include ::WorkbasketHelpers::SettingsSaverHelperMethods

      ATTRS_PARSER_METHODS = %w(
        reason_for_changes
        operation_date
        description
        description_validity_start_date
        parent_geographical_area_group_id
        parent_geographical_area_group_sid
        remove_parent_group_association
        validity_start_date
        validity_end_date
      ).freeze

      attr_accessor :current_step,
                    :save_mode,
                    :settings,
                    :workbasket,
                    :settings_params,
                    :errors,
                    :conformance_errors,
                    :errors_summary,
                    :attrs_parser,
                    :initial_validator,
                    :original_geographical_area,
                    :geographical_area,
                    :geographical_area_description,
                    :geographical_area_description_period,
                    :next_geographical_area_description,
                    :next_geographical_area_description_period,
                    :persist

      def initialize(workbasket, current_step, save_mode, settings_ops = {})
        @workbasket = workbasket
        @save_mode = save_mode
        @current_step = current_step
        @settings = workbasket.settings
        @original_geographical_area = settings.original_geographical_area.decorate
        @settings_params = ActiveSupport::HashWithIndifferentAccess.new(settings_ops)

        setup_attrs_parser!
        clear_cached_sequence_number!

        @persist = true # For now it always true
        @errors = {}
        @errors_summary = {}
        @conformance_errors = {}
      end

      def save!
        workbasket.title = original_geographical_area.geographical_area_id
        workbasket.operation_date = (Date.strptime(operation_date, "%d/%m/%Y") rescue nil)
        workbasket.save

        settings.set_settings_for!(current_step, settings_params)
      end

      def valid?
        validate!
        errors.blank? && conformance_errors.blank?
      end

      def persist!
        @do_not_rollback_transactions = true
        validate!
      end

      def success_ops
        {}
      end

      ATTRS_PARSER_METHODS.map do |option|
        define_method(option) do
          attrs_parser.public_send(option)
        end
      end

    private

      def validate!
        check_initial_validation_rules!
        check_if_nothing_changed! if @errors.blank?
        just_process_membership_changes if @errors.blank? && only_memberships_changed?
        check_conformance_rules! if @errors.blank? && !only_memberships_changed?
      end

      def check_initial_validation_rules!
        @initial_validator = ::WorkbasketInteractions::EditGeographicalArea::InitialValidator.new(
          original_geographical_area, settings_params
        )

        @errors = initial_validator.fetch_errors
        @errors_summary = initial_validator.errors_summary
      end

      def check_if_nothing_changed!
        if nothing_changed?

          p ""
          p "*" * 100
          p ""
          p " NOTHING CHANGED!"
          p ""
          p "*" * 100
          p ""

          @errors[:general] = "Nothing changed"
          @errors_summary = initial_validator.errors_translator(:nothing_changed)
        end
      end

      def nothing_changed?
        original_geographical_area.description.to_s.squish == description.to_s.squish &&
          original_geographical_area.validity_start_date.strftime("%Y-%m-%d") == validity_start_date.try(:strftime, "%Y-%m-%d") &&
          original_geographical_area.validity_end_date.try(:strftime, "%Y-%m-%d") == validity_end_date.try(:strftime, "%Y-%m-%d") &&
          original_geographical_area.parent_geographical_area_group_sid.to_s == parent_geographical_area_group_sid.to_s &&
          memberships_have_no_changes?
      end

      def only_memberships_changed?
        original_geographical_area.description.to_s.squish == description.to_s.squish &&
          original_geographical_area.validity_start_date.strftime("%Y-%m-%d") == validity_start_date.try(:strftime, "%Y-%m-%d") &&
          original_geographical_area.validity_end_date.try(:strftime, "%Y-%m-%d") == validity_end_date.try(:strftime, "%Y-%m-%d") &&
          original_geographical_area.parent_geographical_area_group_sid.to_s == parent_geographical_area_group_sid.to_s &&
          !memberships_have_no_changes?
      end

      def memberships_have_no_changes?
        original_membership_sids = original_geographical_area.member_of_following_geographical_areas.map { |area| area.geographical_area_sid }
        new_membership_sids = settings_params["geographical_area_memberships"].values.map{|area| area["geographical_area_sid"].to_i}
        original_membership_sids == new_membership_sids
      end

      def new_membership_sids
        original_membership_sids = original_geographical_area.member_of_following_geographical_areas.map { |area| area.geographical_area_sid }
        new_membership_sids = settings_params["geographical_area_memberships"].values.map{|area| area["geographical_area_sid"].to_i}
        new_membership_sids.select { |m| !original_membership_sids.include?(m) }
      end

      def just_process_membership_changes
        p '!!!! ONLY MEMBERSHIPS HAVE CHANGES'
        unless new_membership_sids.empty?
          p '@@@@@ THERE ARE NEW MEMBERS'
          add_new_memberships!
        end
        if membership_removed?
          p 'xxxxx THERE ARE MEMBERSHIPS REMOVED'
          end_date_existing_memberships!
        end
      end

      def check_conformance_rules!
        Sequel::Model.db.transaction(@do_not_rollback_transactions.present? ? {} : { rollback: :always }) do
          if it_is_just_description_changed?

            p ""
            p "*" * 100
            p ""
            p " JUST DESC CHANGED 1!"
            p ""
            p "*" * 100
            p ""

            end_date_existing_geographical_area_desription_period!
            add_next_geographical_area_description_period!
            add_next_geographical_area_description!
          else

            p ""
            p "*" * 100
            p ""
            p " ALL CHANGED 1!"
            p ""
            p "*" * 100
            p ""

            end_date_existing_geographical_area!

            add_geographical_area!
            add_geographical_area_description_period!
            add_geographical_area_description!

            if description_validity_start_date.present?
              add_next_geographical_area_description_period!
              add_next_geographical_area_description!
            end
            p '[[[[[[[[[[['
            unless memberships_have_no_changes?
              p '!!!! MEMBERSHIPS HAVE CHANGES'
              unless new_membership_sids.empty?
                p '@@@@@ THERE ARE NEW MEMBERS'
                add_new_memberships!
              end
              if membership_removed?
                p 'xxxxx THERE ARE MEMBERSHIPS REMOVED'
                end_date_existing_memberships!
              end
            end
          end

          parse_and_format_conformance_rules
        end
      end

      def membership_removed?
        settings_params['removed_memberships']
      end

      def add_new_memberships!
        new_membership_sids = new_membership_sids
        new_memberships = settings_params["geographical_area_memberships"].values.select {|area| new_membership_sids.includes?(area['geographical_area_sid'])}
        new_memberships.each do |m|
          @membership = new_membership(m)
          assign_system_ops!(@membership)
          set_primary_key!(@membership)
          @membership.save if persist_mode?
        end
      end

      def new_membership(membership_data)
        if geographical_code == 'group'
          geographical_area = GeographicalArea.where(geographical_area_id: membership_data['geographical_area_id']).first
          group = GeographicalArea.find(geographical_area_id: settings.main_step_settings['geographical_area_id'])
        else
          group = GeographicalArea.where(geographical_area_id: membership_data['geographical_area_id']).first
          geographical_area = GeographicalArea.find(geographical_area_id: settings.main_step_settings['geographical_area_id'])
        end
        GeographicalAreaMembership.new(
          geographical_area_sid: geographical_area.geographical_area_sid,
          geographical_area_group_sid: group[:geographical_area_sid],
          validity_start_date: membership_data['validity_start_date'],
          validity_end_date: membership_data['validity_end_date'],
          workbasket_id: workbasket.id
        )
      end

      def parse_and_format_conformance_rules
        @conformance_errors = {}

        if it_is_just_description_changed?

          p ""
          p "*" * 100
          p ""
          p " JUST DESC CHANGED 2!"
          p ""
          p "*" * 100
          p ""

          unless next_geographical_area_description_period.conformant?
            @conformance_errors.merge!(get_conformance_errors(next_geographical_area_description_period))
          end

          unless next_geographical_area_description.conformant?
            @conformance_errors.merge!(get_conformance_errors(next_geographical_area_description))
          end

        else

          p ""
          p "*" * 100
          p ""
          p " ALL CHANGED 2!"
          p ""
          p "*" * 100
          p ""

          unless geographical_area.conformant?
            @conformance_errors.merge!(get_conformance_errors(geographical_area))
          end

          unless geographical_area_description_period.conformant?
            @conformance_errors.merge!(get_conformance_errors(geographical_area_description_period))
          end

          unless geographical_area_description.conformant?
            @conformance_errors.merge!(get_conformance_errors(geographical_area_description))
          end

          if description_validity_start_date.present?
            unless next_geographical_area_description_period.conformant?
              @conformance_errors.merge!(get_conformance_errors(next_geographical_area_description_period))
            end

            unless next_geographical_area_description.conformant?
              @conformance_errors.merge!(get_conformance_errors(next_geographical_area_description))
            end
          end
        end

        if conformance_errors.present?
          @errors_summary = initial_validator.errors_translator(:summary_conformance_rules)
        end
      end

      def it_is_just_description_changed?
        @it_is_just_description_changed ||= begin
          original_geographical_area.description.to_s.squish != description.to_s.squish &&
            original_geographical_area.validity_start_date.strftime("%Y-%m-%d") == validity_start_date.try(:strftime, "%Y-%m-%d") &&
            original_geographical_area.validity_end_date.try(:strftime, "%Y-%m-%d") == validity_end_date.try(:strftime, "%Y-%m-%d") &&
            original_geographical_area.parent_geographical_area_group_sid.to_s == parent_geographical_area_group_sid.to_s &&
            memberships_have_no_changes?
        end
      end

      def end_date_existing_geographical_area!
        unless original_geographical_area.already_end_dated?
          original_geographical_area.validity_end_date = validity_start_date

          ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
            original_geographical_area, system_ops.merge(operation: "U")
          ).assign!(false)

          original_geographical_area.save
        end
      end

      def end_date_existing_memberships!
        settings_params['removed_memberships'].values.each do |area|
          existing_membership = GeographicalAreaMembership.find(geographical_area_sid: original_geographical_area.geographical_area_sid, geographical_area_group_sid: area['geographical_area_sid'])
          p "&&&&&&&&&&&"
          p "THIS MEMBERSHIP IS GETTING END DATED #{existing_membership.geographical_area_sid}"
          p 'BEFORE'
          byebug
          existing_membership.validity_end_date = operation_date
          existing_membership.save
          byebug
          p "AFTER"
        end
      end

      def end_date_existing_geographical_area_desription_period!
        geographical_area_description_period = original_geographical_area.geographical_area_description
                                                                         .geographical_area_description_period

        unless geographical_area_description_period.already_end_dated?
          geographical_area_description_period.validity_end_date = (description_validity_start_date || validity_start_date)

          ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
            geographical_area_description_period, system_ops.merge(operation: "U")
          ).assign!(false)

          geographical_area_description_period.save
        end
      end

      def add_geographical_area!
        @geographical_area = GeographicalArea.new(
          validity_start_date: validity_start_date,
          validity_end_date: validity_end_date
        )

        geographical_area.geographical_code = original_geographical_area.geographical_code
        geographical_area.geographical_area_id = original_geographical_area.geographical_area_id

        if remove_parent_group_association.present?
          geographical_area.parent_geographical_area_group_sid = nil
        end

        if original_geographical_area.group? && parent_geographical_area_group_id.present?
          geographical_area.parent_geographical_area_group_sid = parent_geographical_area_group_sid
        end

        assign_system_ops!(geographical_area)
        set_primary_key!(geographical_area)

        geographical_area.save if persist_mode?
      end

      def add_geographical_area_description_period!
        @geographical_area_description_period = GeographicalAreaDescriptionPeriod.new(
          validity_start_date: validity_start_date,
          validity_end_date: (description_validity_start_date || validity_end_date)
        )

        geographical_area_description_period.geographical_area_id = geographical_area.geographical_area_id
        geographical_area_description_period.geographical_area_sid = geographical_area.geographical_area_sid

        assign_system_ops!(geographical_area_description_period)
        set_primary_key!(geographical_area_description_period)

        geographical_area_description_period.save if persist_mode?
      end

      def add_geographical_area_description!
        @geographical_area_description = GeographicalAreaDescription.new(
          description: original_geographical_area.description,
          language_id: "EN"
        )

        geographical_area_description.geographical_area_id = geographical_area.geographical_area_id
        geographical_area_description.geographical_area_sid = geographical_area.geographical_area_sid
        geographical_area_description.geographical_area_description_period_sid = geographical_area_description_period.geographical_area_description_period_sid

        assign_system_ops!(geographical_area_description)

        geographical_area_description.save if persist_mode?
      end

      def add_next_geographical_area_description_period!
        @next_geographical_area_description_period = GeographicalAreaDescriptionPeriod.new(
          validity_start_date: (description_validity_start_date || validity_start_date),
          validity_end_date: validity_end_date
        )

        next_geographical_area_description_period.geographical_area_id = (geographical_area || original_geographical_area).geographical_area_id
        next_geographical_area_description_period.geographical_area_sid = (geographical_area || original_geographical_area).geographical_area_sid

        assign_system_ops!(next_geographical_area_description_period)
        set_primary_key!(next_geographical_area_description_period)

        next_geographical_area_description_period.save if persist_mode?
      end

      def add_next_geographical_area_description!
        @next_geographical_area_description = GeographicalAreaDescription.new(
          description: description,
          language_id: "EN"
        )

        next_geographical_area_description.geographical_area_id = (geographical_area || original_geographical_area).geographical_area_id
        next_geographical_area_description.geographical_area_sid = (geographical_area || original_geographical_area).geographical_area_sid
        next_geographical_area_description.geographical_area_description_period_sid = next_geographical_area_description_period.geographical_area_description_period_sid

        assign_system_ops!(next_geographical_area_description)

        next_geographical_area_description.save if persist_mode?
      end

      def add_membership!
        GeographicalAreaMembership.unrestrict_primary_key
        if memberships
          memberships.each do |m|
            membership_data = m.last['geographical_area']
            @membership = new_membership(membership_data)
            assign_system_ops!(@membership)
            set_primary_key!(@membership)
            @membership.save if persist_mode?
          end
        end
      end

      def new_membership(membership_data)
        if geographical_code == 'group'
          geographical_area = GeographicalArea.where(geographical_area_id: membership_data['geographical_area_id']).first
          group = GeographicalArea.find(geographical_area_id: settings.main_step_settings['geographical_area_id'])
        else
          group = GeographicalArea.where(geographical_area_id: membership_data['geographical_area_id']).first
          geographical_area = GeographicalArea.find(geographical_area_id: settings.main_step_settings['geographical_area_id'])
        end
        GeographicalAreaMembership.new(
          geographical_area_sid: geographical_area.geographical_area_sid,
          geographical_area_group_sid: group[:geographical_area_sid],
          validity_start_date: membership_data['validity_start_date'],
          validity_end_date: membership_data['validity_end_date'],
          workbasket_id: workbasket.id
        )
      end

      def persist_mode?
        @persist.present?
      end

      def setup_attrs_parser!
        @attrs_parser = ::WorkbasketValueObjects::EditGeographicalArea::AttributesParser.new(
          settings_params
        )
      end

      def get_conformance_errors(record)
        res = {}

        record.conformance_errors.map do |k, v|
          message = if v.is_a?(Array)
                      v.flatten.join(' ')
                    else
                      v
          end

          res[k.to_s] = "<strong class='workbasket-conformance-error-code'>#{k}</strong>: #{message}".html_safe
        end

        res
      end

      def validator_class(record)
        "#{record.class.name}Validator".constantize
      end
    end
  end
end
