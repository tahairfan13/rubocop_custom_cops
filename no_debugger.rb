# lib/rubocop/cop/custom/no_debugger.rb
module RuboCop
  module Cop
    module Custom
      # Disallow `byebug` or `binding.pry` in committed code.
      class NoDebugger < Cop
        MSG = "Remove debugger (`byebug` or `binding.pry`) before committing."

        def on_send(node)
          if debugger_call?(node)
            add_offense(node, message: MSG)
          end
        end

        private

        def debugger_call?(node)
          (node.method_name == :pry && node.receiver&.source == "binding") ||
            node.method_name == :byebug
        end
      end
    end
  end
end
