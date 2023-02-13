require 'spec_helper'
describe 'devvm' do

  context 'with defaults for all parameters' do
    it { should contain_class('devvm') }
  end
end
