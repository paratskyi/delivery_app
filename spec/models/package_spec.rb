require 'rails_helper'

RSpec.describe Package, type: :model do
  let(:package) { FactoryBot.create(:package) }

  context 'with validation' do
    it 'should be valid' do
      expect(package).to be_valid
    end

    context 'tracking_number' do
      it 'is invalid without a name' do
        expect(FactoryBot.build(:package, tracking_number: nil)).not_to be_valid
      end
    end

    context 'courier' do
      it 'is invalid without courier' do
        expect(FactoryBot.build(:package, courier: nil)).not_to be_valid
      end
    end
  end

  context 'dependent destroy' do
    subject { package.courier.destroy }

    it 'should destroy associated' do
      expect(Package.count).to eq 0
    end
  end
end
