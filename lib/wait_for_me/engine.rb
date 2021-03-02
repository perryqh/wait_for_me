module WaitForMe
  class Engine < ::Rails::Engine
    isolate_namespace WaitForMe

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
