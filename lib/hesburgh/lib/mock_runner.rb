module Hesburgh
  module Lib
    # A class to assist in circumventing the seething underlayer of potential
    # runners and cut quick to the working with the callbacks.
    #
    # @example
    #
    #   context = []
    #   runner = MockRunner.new(context: context, run_with: :input, yields: :yielded_value, callback_name: :success)
    #   runner.run(:input) do |on|
    #     on.success {|output| context << output }
    #   end
    #   context == [:yielded_value]
    #   => true
    #
    # @see Hesrbugh::Lib::Runner
    # @see Hesrbugh::Lib::NamedCallbacks
    class MockRunner
      # Raised when the actual :run_with parameter is different than the
      # expected
      class RunWithMismatchError < RuntimeError
        def initialize(actual: nil, expected: nil)
          super("RunWith Mismatch Error:\nActual: #{actual.inspect}\nExpected: #{expected.inspect}\n")
        end
      end

      def initialize(options = {})
        @yields = options.fetch(:yields)
        @callback_name = options.fetch(:callback_name)
        @run_with = __wrap__(options.fetch(:run_with))

        # Because the context may automatically be getting assigned by the
        # controller.
        @run_with.unshift(options[:context]) if options.key?(:context)
      end

      def run(*args)
        if @run_with == args
          if block_given?
            return yield(self)
          else
            return @callback_name, *@yields
          end
        else
          fail RunWithMismatchError, actual: args, expected: @run_with
        end
      end

      def method_missing(method_name, &_block)
        super unless @callback_name.to_s == method_name.to_s
        return @callback_name, *yield(@yields)
      end

      private

      def __wrap__(object)
        if object.nil?
          []
        elsif object.respond_to?(:to_ary)
          object.to_ary || [object]
        else
          [object]
        end
      end
    end
  end
end
