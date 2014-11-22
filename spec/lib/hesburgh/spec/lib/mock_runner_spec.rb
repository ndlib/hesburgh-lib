require 'spec_helper'
require 'hesburgh/lib/mock_runner'

module Hesburgh
  module Lib
    describe MockRunner do
      context 'with invalid parameters' do
        subject { Hesburgh::Lib::MockRunner.new(run_with: :param, yields: :value, callback_name: :success) }
        it 'raise an exception' do
          expect { subject.run(:bad_param) }.
            to raise_error(MockRunner::RunWithMismatchError)
        end
      end

      context 'with valid callback_name and parameters' do
        context 'with a singular yield' do
          subject { Hesburgh::Lib::MockRunner.new(run_with: :param, yields: yields_value, callback_name: :success) }
          let(:container) { [] }
          let(:yields_value) { :value }
          it 'will yield the singular arg' do
            subject.run(:param) do |on|
              on.success { |arg| container << arg }
            end
            expect(container).to eq([:value])
          end
        end

        context 'with a multi-input' do
          subject { Hesburgh::Lib::MockRunner.new(run_with: [:param1, :param2], yields: yields_value, callback_name: :success) }
          let(:container) { [] }
          let(:yields_value) { :value }
          it 'will yield the singular arg' do
            subject.run(:param1, :param2) do |on|
              on.success { |arg| container << arg }
            end
            expect(container).to eq([:value])
          end
        end

        context 'with two args yield' do
          subject { Hesburgh::Lib::MockRunner.new(run_with: :param, yields: yields_value, callback_name: :success) }
          let(:container) { [] }
          let(:yields_value) { [:value1, :value2] }
          it 'will yield separate items' do
            subject.run(:param) do |on|
              on.success { |one, two| container << one << two }
            end
            expect(container).to eq([:value1, :value2])
          end
        end
      end
    end
  end
end
