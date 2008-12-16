require 'erb_apologist'

ActionController::Base.extend(ERBApologist::HelperMethods)