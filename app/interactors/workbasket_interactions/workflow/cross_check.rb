module WorkbasketInteractions
  module Workflow
    class CrossCheck < ::WorkbasketInteractions::Workflow::ApproveBase
    private

      def post_approve_action!
        workbasket.submit_for_approval!(current_admin: current_user)
      end

      def post_reject_action!
        workbasket.reject_cross_check!(current_admin: current_user)
      end

      def approve_status
        :awaiting_approval
      end

      def reject_status
        :cross_check_rejected
      end

      def blank_mode_validation_message
        :cross_check_mode_blank
      end
    end
  end
end
