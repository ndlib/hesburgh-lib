module Hesburgh
  module Lib
    # A Runner is responsible for performing the guts of what might traditionally
    # be a controller's action.
    #
    # It exists for two reasons, though this is not considered exhaustive:
    # * Controllers are extremely over-worked (parameter negotiation,
    #   authentication, authorization, marshalling an object, user messages via
    #   flash, and http response determination)
    # * The inner method content of a controller's action is subject to change
    #   especially as other implementors look to change the behavior.
    #
    # So, the Runner provides a seem in the code in which you can more readily
    # make changes to the "inner method"  of a route. In some ways, I see this as
    # a separation of state change and response; a somewhat analogous separation
    # to the Command/Query separation principle.
    #
    # @see Hesrbugh::Lib::MockRunner
    class Runner
      def self.run(context, *args, &block)
        new(context, &block).run(*args)
      end

      attr_reader :context
      protected :context

      def initialize(context, callbacks: nil)
        @callbacks = callbacks || default_callbacks
        @context = context
        yield(@callbacks) if block_given?
      end

      def callback(name, *args)
        @callbacks.call(name, *args)
        args
      end

      def run(*_args)
        fail NotImplementedError, ("You must define #{self.class}#run")
      end

      private

      def default_callbacks
        require 'hesburgh/lib/named_callbacks'
        NamedCallbacks.new
      end
    end
  end
end
