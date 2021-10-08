require 'rails_helper'

RSpec.describe Courier, type: :model do
  let(:courier) { create(:courier) }

  it 'email should be saved as lowercase' do
    courier = create(:courier, email: 'Foo@ExAMPle.CoM')
    expect(courier.email).to eq 'foo@example.com'
  end

  it 'has many packages' do
    expect(courier).to respond_to :packages
  end

  context 'with validation' do
    it 'should be valid' do
      expect(courier).to be_valid
    end

    context 'name' do
      it 'is invalid without a name' do
        expect(build(:courier, name: nil)).not_to be_valid
      end

      it 'is invalid with too long name' do
        expect(build(:courier, name: 'a' * 51)).not_to be_valid
      end
    end

    context 'email' do
      it 'is invalid without an email' do
        expect(build(:courier, email: nil)).not_to be_valid
      end

      it 'does not allow duplicate emails' do
        expect(build(:courier, email: courier.email)).not_to be_valid
      end

      it 'is invalid with too long email' do
        expect(build(:courier, email: "#{'a' * 244}@example.com")).not_to be_valid
      end

      it 'allow mixcase valid email' do
        valid_emails = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                          first.last@foo.jp alice+bob@baz.cn]

        valid_emails.each do |email|
          expect(build(:courier, email: email)).to be_valid
        end
      end

      it 'does not allow invalid emails' do
        invalid_emails = %w[foo@bar..com. user@example,com user_at_foo.org
                            user.name@example. foo@bar_baz.com foo@bar+baz.com]

        invalid_emails.each do |email|
          expect(build(:courier, email: email)).not_to be_valid
        end
      end
    end
  end
end
