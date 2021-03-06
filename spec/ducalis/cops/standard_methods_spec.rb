# frozen_string_literal: true

SingleCov.covered!

require 'spec_helper'
require './lib/ducalis/cops/standard_methods'

RSpec.describe Ducalis::StandardMethods do
  subject(:cop) { described_class.new }

  it '[rule] raises if use redefines default ruby methods' do
    inspect_source([
                     'def to_s',
                     '  "my version"',
                     'end'
                   ])
    expect(cop).to raise_violation(/redefine standard/)
  end

  it '[rule] better to define non-default ruby methods' do
    inspect_source([
                     'def present',
                     '  "my version"',
                     'end'
                   ])
    expect(cop).not_to raise_violation
  end
end
