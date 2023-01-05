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
      expect(page).to have_content 'Have no Couriers'
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

    let!(:package) { create(:package, package_params) }
    let(:package_params) { nil }

    it 'does not have "Assign to Courier" action item' do
      expect(page).not_to have_link('Assign to Courier', href: assign_to_courier_admin_package_path(package))
    end

    it_behaves_like :render_correct_show_page

    context 'when delivery_status is processing' do
      let(:package_params) { { delivery_status: 'processing' } }

      it 'renders correct show page' do
        subject
        expect(page).to have_attribute_row('Delivery status', exact_text: 'Processing')
        within '#title_bar .action_items' do
          expect(page).to have_link('Assign to Courier', href: assign_to_courier_admin_package_path(package))
        end
      end
    end

    context 'when package have couriers' do
      let(:couriers) { create_list(:courier, 2) }
      let(:package_params) { { couriers: couriers } }

      it 'render correct couriers table ' do
        subject
        within '#package_table_couriers tbody' do
          expect(page).to have_selector 'tr', count: 2
          couriers.each do |courier|
            expect(page).to have_attribute_cell('Id', exact_text: courier.id)
            expect(page).to have_attribute_cell('Name', exact_text: courier.name)
            expect(page).to have_attribute_cell('Email', exact_text: courier.email)
          end
        end
      end
    end
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

  describe 'assign' do
    subject do
      choose_couriers!
      click_button('Assign couriers')
    end

    before do
      visit admin_package_path(package)
    end

    shared_examples :does_not_assign_couriers_with_correct_flash_error do
      it 'must not be assigned' do
        expect { subject }.not_to change { package.couriers.count }
        expect(page).to have_flash_message(:error, flash_error)
      end
    end

    let!(:package) { create(:package, package_params) }
    let!(:couriers) { create_list(:courier, 4) }
    let(:package_params) { { delivery_status: 'processing' } }
    let(:choose_couriers!) do
      couriers_to_assign.each do |courier|
        find("input[value='#{courier.id}']").click
      end
    end

    context 'when assign one of the available couriers' do
      let(:couriers_to_assign) { couriers[1..1] }
      let(:available_couriers) { couriers - couriers_to_assign }

      it 'successfully assigns Courier' do
        click_link('Assign to Courier')
        within '#assign_table_couriers tbody' do
          expect(page).to have_selector 'tr', count: couriers.count
        end

        expect { subject }.to change { package.couriers.count }.by couriers_to_assign.count

        expect(page).to have_flash_message('Couriers was successfully assigned!')
        within '#package_table_couriers tbody' do
          expect(page).to have_selector 'tr', count: couriers_to_assign.count
        end

        expect(package.couriers.count).to eq couriers_to_assign.count
        expect(package.couriers).to eq couriers_to_assign
        expect(package.reload.delivery_status).to eq 'assigned'
        expect(page).not_to have_link('Assign to Courier', href: assign_to_courier_admin_package_path(package))

        visit admin_assign_to_courier_path(package_id: package.id)

        within '#assign_table_couriers tbody' do
          expect(page).to have_selector 'tr', count: available_couriers.count
          available_couriers.each do |courier|
            expect(page).to have_attribute_cell('Id', exact_text: courier.id)
          end
        end
      end
    end

    context 'when assign all of available couriers' do
      let(:couriers_to_assign) { couriers }
      let(:available_couriers) { couriers - couriers_to_assign }

      it 'successfully assigns Courier' do
        click_link('Assign to Courier')
        within '#assign_table_couriers tbody' do
          expect(page).to have_selector 'tr', count: couriers.count
        end

        expect { subject }.to change { package.couriers.count }.by couriers_to_assign.count

        expect(page).to have_flash_message('Couriers was successfully assigned!')
        within '#package_table_couriers tbody' do
          expect(page).to have_selector 'tr', count: couriers_to_assign.count
        end

        expect(package.couriers.count).to eq couriers_to_assign.count
        expect(package.couriers).to eq couriers_to_assign
        expect(package.reload.delivery_status).to eq 'assigned'
        expect(page).not_to have_link('Assign to Courier', href: assign_to_courier_admin_package_path(package))

        visit admin_assign_to_courier_path(package_id: package.id)

        expect(page).to have_content('Have no available couriers')
      end
    end

    context 'with invalid courier_ids' do
      before do
        allow_any_instance_of(PackageAssignmentService).to receive(:courier_ids).and_return(invalid_courier_ids)
        click_link('Assign to Courier')
      end

      let(:choose_couriers!) { nil }
      let(:invalid_courier_id) { 'invalid_courier_id' }

      context 'when courier_ids is not an Array' do
        let(:invalid_courier_ids) { invalid_courier_id }
        let(:flash_error) { 'Couriers must be an Array of courier ids' }
        it_behaves_like :does_not_assign_couriers_with_correct_flash_error
      end

      context 'when one of courier_ids is invalid' do
        let(:invalid_courier_ids) { [valid_courier_id, invalid_courier_id] }
        let(:valid_courier_id) { couriers.first.id }
        let(:flash_error) { "Couriers \"#{invalid_courier_id}\" is invalid id" }
        it_behaves_like :does_not_assign_couriers_with_correct_flash_error
      end

      context 'when Courier with one of courier_ids does not exist' do
        let(:invalid_courier_ids) { [valid_courier_id, invalid_courier_id] }
        let(:valid_courier_id) { couriers.first.id }
        let(:invalid_courier_id) { couriers.last.id }
        let(:valid_courier_id) { couriers.first.id }
        let(:flash_error) { "Couriers with \"#{invalid_courier_id}\" does not exist" }

        before do
          couriers.last.destroy!
        end

        it_behaves_like :does_not_assign_couriers_with_correct_flash_error
      end
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
