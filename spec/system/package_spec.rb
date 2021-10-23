require 'rails_helper'

RSpec.describe Package, type: :system, js: true do
  before do
    sign_in delivery_manager
  end

  let(:delivery_manager) { create(:delivery_manager) }

  shared_examples :render_correct_show_page do
    let(:delivery_status) { 'New' }

    it 'renders correct show page' do
      subject
      expect(page).to have_content 'Edit Package'
      expect(page).to have_attribute_row('Tracking number', exact_text: /\AYA[0-9]{8}AA\z/)
      expect(page).to have_attribute_row('Delivery status', exact_text: delivery_status)
      expect(page).to have_attribute_row('Created at')
      expect(page).to have_attribute_row('Updated at')
      expect(page).to have_attribute_row('Estimated delivery time', exact_text: package.estimated_delivery_time)
    end
  end

  describe 'index' do
    subject { visit admin_packages_path }

    let!(:packages) { create_list(:package, 3) }

    it 'renders correct index page' do
      subject
      expect(page).to have_content 'New Package'
      within '#index_table_packages tbody' do
        expect(page).to have_selector 'tr', count: 3
        packages.each do |package|
          expect(page).to have_attribute_cell('Tracking number', exact_text: /\AYA[0-9]{8}AA\z/)
          expect(page).to have_attribute_cell('Delivery status', exact_text: package.delivery_status.capitalize)
          expect(page).to have_attribute_cell('Created at')
          expect(page).to have_attribute_cell('Updated at')
          expect(page).to have_attribute_cell('Estimated delivery time', exact_text: package.estimated_delivery_time)
        end
      end
    end
  end

  describe 'show' do
    subject { visit admin_package_path(package) }

    let!(:package) { create(:package) }

    it_behaves_like :render_correct_show_page
  end

  describe 'create' do
    before do
      visit new_admin_package_path
    end

    subject do
      fill_form!
      click_button 'Create Package'
    end

    let(:fill_form!) { nil }
    let(:package) { Package.last }

    it 'creates Package successfully' do
      expect { subject }.to change { Package.count }.by 1
      expect(page).to have_flash_message('Package was successfully created.')
      expect(package.reload).to have_attributes(
        tracking_number: /\AYA[0-9]{8}AA\z/,
        delivery_status: 'new',
        created_at: be_present,
        updated_at: be_present,
        estimated_delivery_time: be_present
      )
    end

    it_behaves_like :render_correct_show_page
  end

  describe 'update' do
    before do
      visit edit_admin_package_path(package_for_edit)
    end

    subject do
      fill_form!
      click_button 'Update Package'
    end

    let(:fill_form!) do
      select new_delivery_status, from: 'package[delivery_status]'
    end

    let(:package_for_edit) { create(:package) }
    let(:package) { Package.last }
    let(:new_delivery_status) { 'Processing' }

    it 'creates Package successfully' do
      expect { subject }.not_to change { Package.count }
      expect(page).to have_flash_message('Package was successfully updated.')
      expect(package).to have_attributes(
        tracking_number: /\AYA[0-9]{8}AA\z/,
        delivery_status: new_delivery_status.downcase,
        created_at: be_present,
        updated_at: be_present,
        estimated_delivery_time: be_present
      )
    end

    it_behaves_like :render_correct_show_page do
      let(:delivery_status) { new_delivery_status }
    end
  end

  describe 'destroy' do
    subject do
      page.accept_confirm do
        click_link 'Delete Package'
      end
    end

    before do
      visit admin_package_path(package)
    end

    let!(:package) { create(:package) }

    it 'destroys package successfully' do
      expect { subject }.to change { Package.count }.by(-1)
      expect(page).to have_flash_message('Package was successfully destroyed.')
    end
  end
end
