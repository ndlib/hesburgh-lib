require 'spec_helper'
require 'hesburgh/lib/runner'

module Hesburgh
  module Lib
    describe Runner do
      Given(:context) { double(invoked: true) }
      Given(:runner) do
        described_class.new(context) do |on|
          on.success { |a, b| context.invoked("SUCCESS", a, b) }
          on.failure { |a, b| context.invoked("FAILURE", a, b) }
          on.other   { |a, b| context.invoked("OTHER", a, b) }
        end
      end

      context "#run" do
        it 'is an abstract method' do
          expect { runner.run }.to raise_error(NotImplementedError)
        end
      end

      context "calling the :other callback" do
        When(:result) { runner.callback(:other, :first, :second) }
        Then { expect(context).to have_received(:invoked).with("OTHER", :first, :second) }
        Then { result == [:first, :second] }
      end

      context "calling an unregistered callback" do
        When(:result) { runner.callback(:unknown, :first, :second) }
        Then { expect(context).to_not have_received(:invoked) }
        Then { result == [:first, :second] }
      end
    end
  end
end
