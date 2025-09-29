# lib/rubocop/cop/custom/migration_safety.rb
module RuboCop
  module Cop
    module Custom
      # Ensures safe migrations by enforcing:
      # - Use of `unless column_exists?` when adding a column
      # - Use of `unless table_exists?` when creating a table
      # - Migration must define `up` and `down`, not `change`
      class MigrationSafety < Cop
        MSG_COLUMN = "Wrap `add_column` inside `unless column_exists?`."
        MSG_TABLE  = "Wrap `create_table` inside `unless table_exists?`."
        MSG_CHANGE = "Use `def up`/`def down` instead of `def change`."

        def on_def(node)
          method_name = node.method_name
          add_offense(node, message: MSG_CHANGE) if method_name == :change
        end

        def on_send(node)
          if node.method_name == :add_column
            add_offense(node, message: MSG_COLUMN) unless wrapped_in_condition?(node, :column_exists?)
          elsif node.method_name == :create_table
            add_offense(node, message: MSG_TABLE) unless wrapped_in_condition?(node, :table_exists?)
          end
        end

        private

        def wrapped_in_condition?(node, method_name)
          parent = node.parent
          return false unless parent&.if_type?

          condition = parent.condition
          condition&.send_type? && condition.method_name == method_name
        end
      end
    end
  end
end
