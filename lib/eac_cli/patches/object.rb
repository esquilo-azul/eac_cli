# frozen_string_literal: true

Dir["#{File.dirname(__FILE__)}/#{::File.basename(__FILE__, '.*')}/*.rb"].sort.each do |path|
  require path
end
