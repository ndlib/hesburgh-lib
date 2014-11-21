module Hesburgh
  module Lib
    # A class to assist in circumventing the seething underlayer of potential
    # runners and cut quick to the working with the callbacks.
    #
    # @example
    #
    #   context = []
    #   runner = MockRunner.new(run_with: :input, yields: :yielded_value, callback_name: :success)
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

      # Raised when the actual :callback_name parameter is different than the
      # expected
      class CallbackNameMismatchError < RuntimeError
        def initialize(actual: nil, expected: nil)
          super("CallbackName Mismatch Error:\nActual: #{actual.inspect}\nExpected: #{expected.inspect}\n")
        end
      end

      def initialize(options = {})
        @yields = options.fetch(:yields)
        @callback_name = options.fetch(:callback_name)
        @run_with = __wrap__(options.fetch(:run_with))
      end

      def run(*args, &block)
        if @run_with == args
          yield(self)
        else
          raise RunWithMismatchError, actual: args, expected: @run_with
        end
      end

      def method_missing(method_name, &block)
        if @callback_name.to_s == method_name.to_s
          yield(@yields)
        else
          raise CallbackNameMismatchError, actual: method_name, expected: @callback_name
        end
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
