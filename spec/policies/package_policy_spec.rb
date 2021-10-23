require 'rails_helper'

RSpec.describe PackagePolicy do
  subject { PackagePolicy.new(delivery_manager, package) }

  let(:package) { create(:package, package_params) }
  let(:delivery_manager) { create(:delivery_manager, delivery_manager_params) }
  let(:delivery_manager_params) { nil }
  let(:package_params) { nil }

  context 'when delivery_manager is enabled' do
    let(:delivery_manager_params) { { enabled: false } }

    it { should_not permit(:show) }
    it { should_not permit(:create) }
    it { should_not permit(:new) }
    it { should_not permit(:update) }
    it { should_not permit(:edit) }
    it { should_not permit(:destroy) }
    it { should_not permit(:destroy) }
    it { should_not permit(:cancel_package) }
  end

  context 'when delivery_manager is disabled' do
    it { should permit(:show) }
    it { should permit(:create) }
    it { should permit(:new) }
    it { should permit(:update) }
    it { should permit(:edit) }
    it { should permit(:destroy) }
    it { should_not permit(:cancel_package) }

    context 'with package delivery_status=processing' do
      let(:package_params) { { delivery_status: 'processing' } }
      it { should_not permit(:cancel_package) }
    end

    context 'with package delivery_status=processing' do
      let(:package_params) { { delivery_status: 'processing' } }
      it { should_not permit(:cancel_package) }
    end

    context 'with package delivery_status=delivered' do
      let(:package_params) { { delivery_status: 'delivered' } }
      it { should permit(:cancel_package) }
    end

    #todo: after US6 will be merged
    context 'with package delivery_status=assigned' do
      let(:package_params) { { delivery_status: 'assigned' } }
      it { should permit(:cancel_package) }
    end
  end
end
