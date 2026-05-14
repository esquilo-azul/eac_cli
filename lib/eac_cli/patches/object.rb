# frozen_string_literal: true

Dir["#{File.dirname(__FILE__)}/#{File.basename(__FILE__, '.*')}/*.rb"].each do |path|
  require path
end
