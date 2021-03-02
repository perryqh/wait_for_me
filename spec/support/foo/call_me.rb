module Foo
  class CallMe
    class << self
      def baz(arg1)
        @@arg1 = arg1
      end

      def no_args_method
        @@no_args_method_called = true
      end

      def arg1
        @@arg1
      end

      def no_args_method_called
        @@no_args_method_called
      end
    end
  end
end