# frozen_string_literal: true

require 'rubocop'

module Ducalis
  class KeywordDefaults < RuboCop::Cop::Cop
    include RuboCop::Cop::DefNode
    OFFENSE = %(
Prefer to use keyword arguments for defaults. \
It increases readability and reduces ambiguities.
    ).strip

    def on_def(node)
      _name, args, _definition = *node
      return unless args
      args.children.each do |arg_node|
        next unless arg_node.type == :optarg
        add_offense(node, :expression, OFFENSE)
      end
    end
    alias on_defs on_def
  end
end
