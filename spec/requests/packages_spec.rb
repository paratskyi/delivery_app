require 'rails_helper'

RSpec.describe "Packages", type: :request do
  let!(:courier) { FactoryBot.create(:courier) }

  describe 'POST #create' do
    subject do
      post packages_path, params: { package: package_params }
    end

    let(:created_package) { Package.last }
    let(:package_attributes) { created_package.attributes }
    let(:package_params) do
      {
        tracking_number: '1111',
        delivery_status: true,
        courier_id: courier.id
      }
    end

    before do
      allow_any_instance_of(PackagesController).to receive(:current_courier).and_return(courier)
    end

    context 'when valid' do
      it 'should create Package successfully' do
        expect { subject }.to change { Package.count }.by(1)
        expect((package_attributes)).to match hash_including(
                                                'id' => created_package.id,
                                                'tracking_number' => '1111',
                                                'delivery_status' => true,
                                                'courier_id' => courier.id
                                              )
        expect(subject).to redirect_to courier_path(courier)
      end

      context 'with no delivery status' do
        let(:package_params) do
          {
            tracking_number: '1111',
            courier_id: courier.id
          }
        end

        it 'should create Package successfully' do
          expect { subject }.to change { Package.count }.by(1)
          expect((package_attributes)).to match hash_including(
                                                  'id' => created_package.id,
                                                  'tracking_number' => '1111',
                                                  'delivery_status' => false,
                                                  'courier_id' => courier.id
                                                )
          expect(subject).to redirect_to courier_path(courier)
        end
      end
    end

    context 'when invalid' do
      context 'with empty params' do
        let(:package_params) do
          {
            tracking_number: '',
            delivery_status: nil,
            courier_id: nil
          }
        end

        it 'does not create Package' do
          expect { subject }.to change { Package.count }.by(0)
        end
      end

      context 'with empty tracking_number' do
        let(:package_params) do
          {
            tracking_number: '',
            courier_id: courier.id
          }
        end

        it 'does not create Package' do
          expect { subject }.to change { Package.count }.by(0)
        end
      end

      context 'duplicate tracking_number' do
        let(:package_params) do
          {
            tracking_number: created_package.tracking_number,
            courier_id: courier.id
          }
        end

        before do
          FactoryBot.create(:package)
        end

        it 'does not create Package' do
          expect { subject }.to change { Package.count }.by(0)
        end
      end
    end
  end
end
