# frozen_string_literal: true

Oj.optimize_rails

Blueprinter.configure do |config|
  config.generator = Oj
end
