require "rails_helper"

describe ParseClient do
  subject { described_class.new }

  it { should respond_to :schema }
end
