require 'rails_helper'

RSpec.describe DeliveryManager, type: :model do
  describe '#create' do
    subject { DeliveryManager.create(create_params) }

    let(:create_params) { FactoryBot.attributes_for(:delivery_manager) }

    shared_examples :create_delivery_manager_with_correct_attributes do
      let(:enabled) { true }
      it 'creates DeliveryManager with correct attributes' do
        expect { subject }.to change { DeliveryManager.count }.by(1)
        expect(subject.errors.messages).to be_empty
        expect(DeliveryManager.last).to have_attributes(
          id: be_a_kind_of(String),
          enabled: enabled,
          email: create_params[:email],
          created_at: be_present,
          updated_at: be_present
        )
      end
    end

    shared_examples :does_not_create_delivery_manager_with_correct_errors do
      let(:errors) { nil }

      it 'does not creates DeliveryManager with correct errors' do
        expect { subject }.to change { DeliveryManager.count }.by(0)
        expect(subject.errors.full_messages).to match_array(errors)
      end
    end

    context 'with required params' do
      it_behaves_like :create_delivery_manager_with_correct_attributes
    end

    context 'with empty params' do
      let(:create_params) { {} }

      it_behaves_like :does_not_create_delivery_manager_with_correct_errors do
        let(:errors) { ["Email can't be blank", "Password can't be blank"] }
      end
    end

    context 'with enabled=false' do
      let(:enabled) { false }
      let(:create_params) { super().merge(enabled: enabled) }

      it_behaves_like :create_delivery_manager_with_correct_attributes
    end
  end

  context '#update' do
    subject { delivery_manager.update(update_params) }

    let!(:delivery_manager) { FactoryBot.create(:delivery_manager) }
    let(:update_params) { {} }

    shared_examples :update_delivery_manager_with_correct_attributes do
      it 'creates DeliveryManager with correct attributes' do
        expect { subject }.to change { DeliveryManager.count }.by(0)
        expect(delivery_manager.errors.messages).to be_empty
        expect(delivery_manager).to have_attributes(
          id: be_a_kind_of(String),
          enabled: enabled,
          created_at: be_present,
          updated_at: be_present
        )
      end
    end

    context 'when update enabled' do
      let(:update_params) { super().merge(enabled: enabled) }
      let(:enabled) { false }

      it_behaves_like :update_delivery_manager_with_correct_attributes
    end
  end
end
