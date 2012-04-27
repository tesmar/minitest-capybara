module MiniTest
  module CapybaraExtension

    def self.included(base)
      base.class_eval do; class << self

        def it_with_capybara desc, params={}, &block
          if params[:js] == true

            javascript_block = proc do
              Capybara.current_driver = :selenium
            begin
              block.call
            ensure
              Capybara.current_driver = :rack_test
            end

            end

            self.it_old desc, &javascript_block
          else
            self.it_old desc, &block
          end
        end

        alias_method :it_old, :it
        alias_method :it, :it_with_capybara

      end; end
    end
  end
end

MiniTest::Spec.send :include, MiniTest::CapybaraExtension
