require 'rails_helper'

RSpec.describe Package, type: :model do
  let(:courier) { create(:courier) }

  describe '#create' do
    subject { Package.create(create_params) }

    let(:create_params) { { courier: courier } }

    shared_examples :create_package_with_correct_attributes do
      let(:delivery_status) { 'new' }

      it 'creates Package with correct attributes' do
        expect { subject }.to change { Package.count }.by(1)
        expect(subject.errors.messages).to be_empty
        expect(Package.last).to have_attributes(
          tracking_number: match(/\AYA[0-9]{8}AA\z/),
          created_at: be_present,
          updated_at: be_present,
          id: be_a_kind_of(String),
          courier_id: courier.id,
          delivery_status: delivery_status,
          estimated_delivery_time: be_present
        )
      end
    end

    shared_examples :does_not_create_package do
      let(:errors) { nil }

      it 'does not creates Package' do
        expect { subject }.not_to change { Package.count }
        expect(subject.errors.full_messages).to match_array(errors)
      end
    end

    shared_examples :does_not_create_package_with_raise_error do
      let(:invalid_delivery_status) { nil }

      it 'does not creates Package with raises ArgumentError' do
        expect { subject }.to raise_error(
          ArgumentError, "'#{invalid_delivery_status}' is not a valid delivery_status"
        ).and change { Package.count }.by(0)
      end
    end

    context 'with required params' do
      it_behaves_like :create_package_with_correct_attributes
    end

    context 'with valid delivery_statuses' do
      Package.delivery_statuses.each_key do |delivery_status|
        it_behaves_like :create_package_with_correct_attributes do
          let(:delivery_status) { delivery_status }
          let(:create_params) { super().merge(delivery_status: delivery_status) }
        end
      end
    end

    context 'with empty delivery statuses' do
      empty_delivery_statuses = ['', ' ', nil]

      empty_delivery_statuses.each do |empty_delivery_status|
        it_behaves_like :does_not_create_package do
          let(:errors) { ['Delivery status is not included in the list'] }
          let(:create_params) { super().merge(delivery_status: empty_delivery_status) }
        end
      end
    end

    context 'with invalid delivery statuses' do
      invalid_delivery_statuses = Faker::Lorem.words

      invalid_delivery_statuses.each do |invalid_delivery_status|
        it_behaves_like :does_not_create_package_with_raise_error do
          let(:invalid_delivery_status) { invalid_delivery_status }
          let(:create_params) { super().merge(delivery_status: invalid_delivery_status) }
        end
      end
    end

    context 'with empty params' do
      let(:create_params) { {} }

      it_behaves_like :does_not_create_package do
        let(:errors) { ['Courier must exist', "Courier can't be blank"] }
      end
    end

    context 'with duplicated tracking_number' do
      before do
        allow_any_instance_of(Package).to receive(:generate_tracking_number).and_return('YA00000001AA')
        create(:package, courier: courier)
      end

      it_behaves_like :does_not_create_package do
        let(:errors) { ['Tracking number has already been taken'] }
      end
    end
  end

  describe '#update' do
    subject { package.update(update_params) }

    let!(:package) { create(:package) }
    let(:update_params) { { courier: courier } }

    shared_examples :update_package_with_correct_attributes do
      let(:delivery_status) { 'new' }

      it 'updates Package with correct attributes' do
        expect { subject }.not_to change { Package.count }
        expect(package.errors.messages).to be_empty
        expect(package.reload).to have_attributes(
          tracking_number: match(/\AYA[0-9]{8}AA\z/),
          created_at: be_present,
          updated_at: be_present,
          id: be_a_kind_of(String),
          courier_id: courier.id,
          delivery_status: delivery_status,
          estimated_delivery_time: be_present
        )
      end
    end

    shared_examples :does_not_update_package do
      let(:errors) { nil }

      it 'does not updates Package' do
        expect { subject }.not_to change { Package.count }
        expect(package.errors.full_messages).to match_array(errors)
      end
    end

    shared_examples :does_not_update_package_with_raise_error do
      let(:invalid_delivery_status) { nil }

      it 'does not updates Package with raises ArgumentError' do
        expect { subject }.to raise_error(
          ArgumentError, "'#{invalid_delivery_status}' is not a valid delivery_status"
        ).and change { Package.count }.by(0)
      end
    end

    context 'when update Courier' do
      it_behaves_like :update_package_with_correct_attributes
    end

    context 'with valid delivery_statuses' do
      Package.delivery_statuses.each_key do |delivery_status|
        it_behaves_like :update_package_with_correct_attributes do
          let(:delivery_status) { delivery_status }
          let(:update_params) { super().merge(delivery_status: delivery_status) }
        end
      end
    end

    context 'with empty delivery statuses' do
      empty_delivery_statuses = ['', ' ', nil]

      empty_delivery_statuses.each do |empty_delivery_status|
        it_behaves_like :does_not_update_package do
          let(:errors) { ['Delivery status is not included in the list'] }
          let(:update_params) { super().merge(delivery_status: empty_delivery_status) }
        end
      end
    end

    context 'with invalid delivery statuses' do
      invalid_delivery_statuses = Faker::Lorem.words

      invalid_delivery_statuses.each do |invalid_delivery_status|
        it_behaves_like :does_not_update_package_with_raise_error do
          let(:invalid_delivery_status) { invalid_delivery_status }
          let(:update_params) { super().merge(delivery_status: invalid_delivery_status) }
        end
      end
    end

    context 'with duplicated tracking_number' do
      let!(:another_package) { create(:package, courier: courier) }
      let(:update_params) { super().merge(tracking_number: another_package.tracking_number) }

      it_behaves_like :does_not_update_package do
        let(:errors) { ['Tracking number has already been taken'] }
      end
    end
  end

  describe 'associations' do
    let(:package) { create(:package) }

    it 'has many posts' do
      expect(package).to respond_to :courier
    end
  end
end
