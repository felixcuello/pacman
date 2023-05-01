# frozen_string_literal: true

require 'rspec'

Dir.glob("lib/**/*.rb").each do |file|
  require_relative "../#{file}"
end
