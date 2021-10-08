require 'rails_helper'

RSpec.describe 'Authentication', type: :system, js: true do
  before { sign_in delivery_manager }
  subject { visit admin_root_path }

  let(:delivery_manager) { FactoryBot.create(:delivery_manager, enabled: enabled) }

  context 'when enabled delivery_manager' do
    let(:enabled) { true }

    it 'authenticates successfully' do
      subject
      expect(page).to have_content delivery_manager.email
      expect(page).to have_link 'Logout'
    end
  end

  context 'when disabled delivery_manager' do
    let(:enabled) { false }

    it 'does not authenticates with valid error' do
      subject
      expect(page).to have_content 'Login'
      expect(page).to have_content 'Your profile is disabled'
    end
  end
end
