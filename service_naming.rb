# lib/rubocop/cop/custom/service_naming.rb
module RuboCop
  module Cop
    module Custom
      # Enforces that all service classes:
      # - Live in app/services/
      # - Class names must end with "Service"
      class ServiceNaming < Cop
        MSG_PATH  = "Service classes must be placed under `app/services/`."
        MSG_CLASS = "Service class name must end with `Service`."

        def on_class(node)
          class_name = node.identifier.const_name
          file_path = processed_source.file_path

          unless file_path.include?("app/services/")
            add_offense(node, message: MSG_PATH)
          end

          unless class_name.end_with?("Service")
            add_offense(node, message: MSG_CLASS)
          end
        end
      end
    end
  end
end
