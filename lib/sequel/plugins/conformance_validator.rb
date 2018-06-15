module Sequel
  module Plugins
    module ConformanceValidator
      def self.configure(model, options = {})
        # Delegations
        model.delegate :conformance_validator, to: model
      end

      module InstanceMethods
        def conformance_errors
          @conformance_errors ||= Sequel::Model::Errors.new
        end

        def conformant?
          conformance_validator.validate(self)

          conformance_errors.none?
        end

        def conformant_for?(*operations)
          conformance_validator.validate_for_operations(self, *operations)

          conformant?
        end

        def valid?
          super() && conformant?
        end

        def errors
          e = super()
          e.merge!(conformance_errors)

          e
        end

        def before_save
          cancel_action unless conformant?

          super
        end

        def before_destroy
          cancel_action unless conformant_for?(:destroy)
        end
      end

      module ClassMethods
        def conformance_validator
          @_conformance_validator ||= begin
                            "#{self}Validator".constantize.new
                          rescue NameError
                            NullValidator
                          end
        end

        def conformance_validator=(conformance_validator)
          @_conformance_validator = conformance_validator
        end

        def raise_on_save_failure
          false
        end
        # def raise_on_save_failure
        #   false
        # end
      end
    end
  end
end
