require 'rails_helper'

RSpec.describe DeliveryManager, type: :model do

  describe 'fields' do
    it { should have_db_column(:enabled).of_type(:boolean).with_options(default: true) }
  end

  describe '#create' do
    subject { DeliveryManager.create(create_params) }

    let(:create_params) { {} }

    shared_examples :create_delivery_manager_with_correct_attributes do
      it 'creates DeliveryManager with correct attributes' do
        expect { subject }.to change { DeliveryManager.count }.by(1)
        expect(subject.errors.messages).to be_empty
        expect(subject).to have_attributes(
          id: be_a_kind_of(String),
          enabled: enabled,
          created_at: be_present,
          updated_at: be_present
        )
      end
    end

    context 'with empty params' do
      let(:enabled) { true }

      it_behaves_like :create_delivery_manager_with_correct_attributes
    end

    context 'with enabled=false' do
      let(:create_params) { super().merge(enabled: enabled) }
      let(:enabled) { false }

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
