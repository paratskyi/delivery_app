require 'rails_helper'

RSpec.describe 'Couriers', type: :request do
  let!(:courier) { FactoryBot.create(:courier) }

  describe 'GET /index' do
    subject do
      get couriers_path
    end

    let!(:couriers) { FactoryBot.create_list(:courier, 10) }

    it 'returns http success' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'should render correct index page' do
      subject
      expect(response.body).to include 'Couriers'
    end

    it 'should show couriers correctly' do
      couriers.each do |courier|
        subject
        expect(response.body).to include courier_path(courier)
      end
    end
  end

  describe 'GET /show' do
    subject do
      get courier_path(courier)
    end

    it 'returns http success' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'should render correct show page' do
      subject
      expect(response.body).to include "#{courier.name}'s profile"
      expect(response.body).to include edit_courier_path(courier)
    end

    it 'should show courier correctly' do
      #TODO add test after adding assotiations
    end
  end

  describe 'GET /new' do
    subject do
      get new_courier_path
    end

    it 'returns http success' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'should render correct new page' do
      subject
      expect(response.body).to include 'Create courier'
      expect(response.body).to include couriers_path
    end
  end

  describe 'GET /edit' do
    subject do
      get edit_courier_path(courier)
    end

    it 'returns http success' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'should render correct new page' do
      subject
      expect(response.body).to include 'Edit courier'
      expect(response.body).to include 'Update courier'
    end

    it 'should show courier correctly' do
      subject
      expect(response.body).to include "#{courier.name}"
      expect(response.body).to include "#{courier.email}"
    end
  end

  describe 'POST #create' do
    subject do
      post couriers_path, params: { courier: courier_params }
    end

    let(:created_courier) { Courier.last }
    let(:courier_attributes) { created_courier.attributes }
    let(:courier_params) do
      {
        name: 'name',
        email: 'example@email.com'
      }
    end

    context 'when valid' do
      it 'should create Courier successfully' do
        expect { subject }.to change { Courier.count }.by(1)
        expect((courier_attributes)).to match hash_including(
          'id' => created_courier.id,
          'name' => 'name',
          'email' => 'example@email.com'
        )
        expect(subject).to redirect_to courier_path(created_courier)
      end
    end

    context 'when invalid' do
      shared_examples :courier_does_not_create do
        let(:errors) { nil }

        it 'does not create Courier' do
          expect { subject }.to change { Courier.count }.by(0)
          expect(response).to have_http_status(:success)
          expect(response.body).to include 'The following errors prevented the courier from being saved'
        end

        it 'shows errors' do
          subject
          errors.each do |error|
            expect(response.body).to include error
          end
        end
      end

      context 'with empty params' do
        let(:courier_params) do
          {
            name: '',
            email: ''
          }
        end

        include_examples :courier_does_not_create do
          let(:errors) { ['Email is invalid', 'Email can&#39;t be blank', 'Name can&#39;t be blank'] }
        end
      end

      context 'with empty name' do
        let(:courier_params) do
          {
            name: '',
            email: ''
          }
        end

        include_examples :courier_does_not_create do
          let(:errors) { ['Name can&#39;t be blank'] }
        end
      end

      context 'with empty email' do
        let(:courier_params) do
          {
            name: 'name',
            email: ''
          }
        end

        include_examples :courier_does_not_create do
          let(:errors) { ['Email is invalid', 'Email can&#39;t be blank'] }
        end
      end

      context 'not correct email' do
        let(:courier_params) do
          {
            name: 'name',
            email: 'invalid_email'
          }
        end

        include_examples :courier_does_not_create do
          let(:errors) { ['Email is invalid'] }
        end
      end

      context 'duplicate email' do
        let(:courier_params) do
          {
            name: 'name',
            email: created_courier.email
          }
        end

        before do
          FactoryBot.create(:courier)
        end

        include_examples :courier_does_not_create do
          let(:errors) { ['Email has already been taken'] }
        end
      end
    end
  end

  describe 'PATCH #update' do
    subject do
      patch courier_path(courier), params: { courier: courier_params }
    end

    let(:courier_attributes) { courier.reload.attributes }
    let(:courier_params) do
      {
        name: 'new name',
        email: 'new@email.com'
      }
    end

    context 'when valid' do
      it 'should update Courier successfully' do
        expect { subject }.to change { Courier.count }.by(0)
        expect((courier_attributes)).to match hash_including(
          'id' => courier.id,
          'name' => 'new name',
          'email' => 'new@email.com'
        )
        expect(subject).to redirect_to courier_path(courier)
      end
    end

    context 'when invalid' do
      shared_examples :courier_does_not_create do
        let(:errors) { nil }

        it 'does not update Courier' do
          expect { subject }.to change { Courier.count }.by(0)
          expect(response).to have_http_status(:success)
          expect(response.body).to include 'The following errors prevented the courier from being saved'
        end

        it 'shows errors' do
          subject
          errors.each do |error|
            expect(response.body).to include error
          end
        end
      end

      context 'with empty params' do
        let(:courier_params) do
          {
            name: '',
            email: ''
          }
        end

        include_examples :courier_does_not_create do
          let(:errors) { ['Email is invalid', 'Email can&#39;t be blank', 'Name can&#39;t be blank'] }
        end
      end

      context 'with empty name' do
        let(:courier_params) do
          {
            name: '',
            email: ''
          }
        end

        include_examples :courier_does_not_create do
          let(:errors) { ['Name can&#39;t be blank'] }
        end
      end

      context 'with empty email' do
        let(:courier_params) do
          {
            name: 'name',
            email: ''
          }
        end

        include_examples :courier_does_not_create do
          let(:errors) { ['Email is invalid', 'Email can&#39;t be blank'] }
        end
      end

      context 'not correct email' do
        let(:courier_params) do
          {
            name: 'name',
            email: 'invalid_email'
          }
        end

        include_examples :courier_does_not_create do
          let(:errors) { ['Email is invalid'] }
        end
      end

      context 'duplicate email' do
        let(:courier_params) do
          {
            name: 'name',
            email: another_courier.email
          }
        end

        let!(:another_courier) { FactoryBot.create(:courier) }

        include_examples :courier_does_not_create do
          let(:errors) { ['Email has already been taken'] }
        end
      end
    end
  end
end
