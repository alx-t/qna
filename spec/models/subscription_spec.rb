require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should validate_presence_of :subscriber }
  it { should validate_presence_of :subscription }
  it { should belong_to :subscriber }
  it { should belong_to :subscription }
end
