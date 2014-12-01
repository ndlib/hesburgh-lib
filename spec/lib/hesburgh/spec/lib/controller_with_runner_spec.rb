require 'spec_helper'
require 'hesburgh/lib/controller_with_runner'

module Hesburgh
  module Lib
    describe ControllerWithRunner do
      let(:controller) { TestController.new }
      before do
        module TestContainer
          class Show
          end
          class Custom
          end
        end

        module TestOverrideContainer
        end

        class TestController
          attr_accessor :action_name
          include ControllerWithRunner
          self.runner_container = TestContainer
        end
      end

      after do
        Hesburgh::Lib.send(:remove_const, :TestController)
        Hesburgh::Lib.send(:remove_const, :TestContainer)
        Hesburgh::Lib.send(:remove_const, :TestOverrideContainer)
      end

      context 'runner_container' do
        it 'should be assignable at the instance level without overriding the class' do
          expect { controller.runner_container = TestOverrideContainer }.
            to_not change { controller.class.runner_container }
          expect(controller.runner_container).to eq(TestOverrideContainer)
        end

        it 'should be assignable at the class level' do
          TestController.runner_container = TestContainer
          expect(TestController.runner_container).to eq(TestContainer)
        end
      end

      context '#runner' do
        before do
          controller.action_name = 'show'
        end
        it 'will use the custom runner_name' do
          expect(controller.runner('Custom')).to eq(TestContainer::Custom)
        end
        it 'will extrapolate the runner based on the action_name' do
          expect(controller.runner).to eq(TestContainer::Show)
        end
        it 'allows for dependency inject by using the instance\'s @runner' do
          my_runner = double(run: true)
          controller.runner = my_runner
          expect(controller.runner).to eq(my_runner)
        end
        it 'guards against incorrect assignment of a runner' do
          expect { controller.runner = :ted }.
            to raise_error(Hesburgh::Lib::ControllerWithRunner::ImproperRunnerError)
        end
        it 'raises an exception if the runner cannot be found' do
          controller.action_name = 'this_is_missing'
          expect { controller.runner }.
            to raise_error(Hesburgh::Lib::ControllerWithRunner::RunnerNotFoundError)
        end
      end

      context '#run' do
        it 'uses the runner passing the controller and args' do
          my_runner = double(run: true)
          controller.runner = my_runner
          controller.run(:hello)
          expect(my_runner).to have_received(:run).with(controller, :hello)
        end
        it 'it yields a block to the caller' do
          my_runner = double(run: true)
          expect(my_runner).to receive(:run).with(controller, :hello).and_yield
          controller.runner = my_runner
          controller.run(:hello) do
            @yielded = true
          end
          expect(@yielded).to eq(true)
        end
      end
    end
  end
end
