require 'spec_helper'
require 'hesburgh/lib/named_callbacks'

module Hesburgh
  module Lib
    describe NamedCallbacks do
      let(:named_callback) { described_class.new }
      let(:context) { [ ] }
      before do
        named_callback.my_named_callback { |*a| context.replace(a) }
      end

      describe "with a named callback" do
        let(:callback_name) { :my_named_callback }
        it 'calls the callback' do
          named_callback.call(callback_name, 'a',:hello)
          expect(context).to eq(['a', :hello])
        end
      end

      describe "with a named callback called by a string" do
        let(:callback_name) { 'my_named_callback' }
        it 'calls the callback' do
          named_callback.call(callback_name, 'a',:hello)
          expect(context).to eq(['a', :hello])
        end
      end

      describe "with a undeclared callback" do
        it 'does not call anything (nor does it raise an exception)' do
          named_callback.call(:undeclared_callback, 1, 2, 3)
          expect(context).to eq([])
        end
      end
    end
  end
end
