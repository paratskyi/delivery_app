require 'rails_helper'

RSpec.describe Courier, type: :model do
  let(:attributes_for_courier) { attributes_for(:courier) }

  it 'email should be saved as lowercase' do
    courier = create(:courier, email: 'Foo@ExAMPle.CoM')
    expect(courier.email).to eq 'foo@example.com'
  end

  describe '#create' do
    subject { Courier.create(create_params) }

    let(:create_params) { attributes_for_courier }

    context 'with empty params' do
      let(:create_params) { nil }

      it_behaves_like :does_not_create_record do
        let(:errors) do
          ["Email can't be blank", 'Email is invalid', "Name can't be blank"]
        end
      end
    end

    context 'with required params' do
      it_behaves_like :create_record_with_correct_attributes do
        let(:record_attributes) do
          {
            name: create_params[:name],
            email: create_params[:email],
            created_at: be_present,
            updated_at: be_present
          }
        end
      end
    end

    context 'with duplicated email' do
      let!(:another_courier) { create(:courier) }
      let(:create_params) { super().merge(email: another_courier.email) }

      it_behaves_like :does_not_create_record do
        let(:errors) { ['Email has already been taken'] }
      end
    end
  end

  describe '#update' do
    subject { courier.update(update_params) }

    let!(:courier) { create(:courier) }
    let(:update_params) { attributes_for_courier }

    it_behaves_like :update_record_with_correct_attributes do
      let(:record) { courier }
      let(:record_attributes) do
        {
          name: update_params[:name],
          email: update_params[:email],
          created_at: be_present,
          updated_at: be_present
        }
      end
    end

    context 'with duplicated email' do
      let!(:another_courier) { create(:courier) }
      let(:update_params) { super().merge(email: another_courier.email) }

      it_behaves_like :does_not_update_record do
        let(:record) { courier }
        let(:errors) { ['Email has already been taken'] }
      end
    end
  end

  describe 'fields' do
    it { should have_db_column(:name).of_type(:string).with_options(null: false) }
    it { should have_db_column(:email).of_type(:string).with_options(null: false) }
  end

  describe 'validations' do
    subject { FactoryBot.build(:courier) }

    before do
      allow_any_instance_of(Courier).to receive(:downcase_email)
    end

    invalid_emails = %w[foo@bar..com. user@example,com user_at_foo.org
                        user.name@example. foo@bar_baz.com foo@bar+baz.com]

    valid_emails = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                      first.last@foo.jp alice+bob@baz.cn]

    it { should_not allow_value(nil).for(:name) }
    it { should_not validate_length_of(:name).is_at_most(51) }
    it { should_not allow_value(nil).for(:email) }
    it { should_not validate_length_of(:email).is_at_most(256) }
    it { should_not allow_value(*invalid_emails).for(:email) }
    it { should allow_value(*valid_emails).for(:email) }
    it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
  end

  describe 'associations' do
    it { should have_many(:packages).through(:package_assignments) }
  end
end
