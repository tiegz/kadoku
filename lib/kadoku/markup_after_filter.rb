module Kadoku
  # An ActionController after_filter.
  #
  # Note: Kadoku is still experimental and isn't guaranteed to not break your html. 
  #       You might need to restyle some things, so I wouldn't use it untested in Production env.
  #
  # Example:
  #
  #   class Application < ActionController::Base
  #     ... all your filters here
  #     after_filter Kadoku::MarkupAfterFilter
  #   end
  class MarkupAfterFilter
    def self.filter(controller)
      controller.response.body = Markup.new(controller.response.body)
    end
  end
end