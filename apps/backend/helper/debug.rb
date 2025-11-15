# frozen_string_literal: true

# rbs_inline: enabled

module Debug
  # @rbs (untyped obj) -> void
  def debug_object(obj)
    obj.instance_variables.each do |var|
      puts "#{var} => #{obj.instance_variable_get(var)}"
    end
  end
end
