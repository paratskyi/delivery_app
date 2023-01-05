require 'rails_helper'

RSpec.describe CourierPolicy do
  subject { CourierPolicy.new(delivery_manager, courier) }

  let(:courier) { create(:courier) }
  let(:delivery_manager) { create(:delivery_manager, delivery_manager_params) }
  let(:delivery_manager_params) { nil }

  context 'when delivery_manager is disabled' do
    let(:delivery_manager_params) { { enabled: false } }

    it { should_not permit(:show) }
    it { should_not permit(:create) }
    it { should_not permit(:new) }
    it { should_not permit(:update) }
    it { should_not permit(:edit) }
    it { should_not permit(:destroy) }
  end

  context 'when delivery_manager is enabled' do
    it { should permit(:show) }
    it { should permit(:create) }
    it { should permit(:new) }
    it { should permit(:update) }
    it { should permit(:edit) }
    it { should permit(:destroy) }
  end
end
