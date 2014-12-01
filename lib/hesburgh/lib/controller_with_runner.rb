require 'active_support/concern'
require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/string/inflections'

module Hesburgh
  module Lib
    # Exposes a way for connecting a set of Runners into your application.
    # A runner allows you to tease out Action level logic into its own custom
    # class.
    #
    # @see Hesburgh::Lib::Runner
    module ControllerWithRunner
      extend ActiveSupport::Concern

      included do
        # Because yardoc's scope imperative does not appear to work, I'm pushing the
        # comments into the class definition
        class << self
          # @!attribute [rw] runner_container
          #   So you can specify where you will be finding an action's Runner
          #   class.
          #
          #   @see #run
        end
        class_attribute :runner_container
      end

      # So you can more easily decouple the controller's command behavior and
      # response behavior.
      #
      # @example
      #   def index
      #     run(specific_params) do |on|
      #       on.success { |collection|
      #         @collection = collection
      #         respond_with(@collection)
      #       }
      #     end
      #   end
      #
      # @see .runner_container for customization
      def run(*args, &block)
        runner.run(self, *args, &block)
      end

      # A query to lookup the appropriate Runner class
      def runner(runner_name = nil)
        return @runner if @runner # For Dependency Injection
        runner_name = action_name.classify unless runner_name
        if runner_container.const_defined?(runner_name)
          runner_container.const_get(runner_name)
        else
          fail RunnerNotFoundError, container: runner_container, name: runner_name
        end
      end

      # Exposed for purposes of Dependency Injection.
      def runner=(object)
        fail(ImproperRunnerError, runner: object, method_name: :run) unless object.respond_to?(:run)
        @runner = object
      end

      # Raised when a Runner is not found
      class RunnerNotFoundError < RuntimeError # :nodoc:
        def initialize(options = {})
          super("Unable to find #{options.fetch(:name)} in #{options.fetch(:container)}")
        end
      end

      # Raised when a Runner is not found
      class ImproperRunnerError < RuntimeError # :nodoc:
        def initialize(options = {})
          super("Expected #{options.fetch(:runner)} to respond_to #{options.fetch(:method_name)}")
        end
      end
    end
  end
end
