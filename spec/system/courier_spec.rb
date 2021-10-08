require 'rails_helper'

RSpec.describe Courier, type: :system, js: true do
  before do
    sign_in delivery_manager
  end

  let(:delivery_manager) { create(:delivery_manager) }

  shared_examples :render_correct_show_page do
    it 'renders correct show page' do
      subject
      expect(page).to have_content 'Edit Courier'
      expect(page).to have_attribute_row('Name', exact_text: courier.name)
      expect(page).to have_attribute_row('Email', exact_text: courier.email)
    end
  end

  describe 'index' do
    subject { visit admin_couriers_path }

    let!(:couriers) { create_list(:courier, 3) }

    it 'renders correct index page' do
      subject
      expect(page).to have_content 'New Courier'
      within '#index_table_couriers tbody' do
        expect(page).to have_selector 'tr', count: 3
        couriers.each do |courier|
          expect(page).to have_attribute_cell('Id', exact_text: courier.id)
          expect(page).to have_attribute_cell('Name', exact_text: courier.name)
          expect(page).to have_attribute_cell('Email', exact_text: courier.email)
        end
      end
    end
  end

  describe 'show' do
    subject { visit admin_courier_path(courier) }

    let!(:courier) { create(:courier) }

    it_behaves_like :render_correct_show_page
  end

  describe 'create' do
    before do
      visit new_admin_courier_path
    end

    subject do
      fill_form!
      click_button 'Create Courier'
    end

    let(:fill_form!) { nil }
    let(:courier_attributes) { attributes_for(:courier) }
    let(:courier) { Courier.last }

    it 'mappable errors should be displayed' do
      expect { subject }.not_to change { Courier.count }
      expect(page).to have_semantic_errors(count: 2)
      expect(page).to have_semantic_errors("Name can't be blank")
      expect(page).to have_semantic_errors("Email can't be blank and is invalid")
    end

    context 'when enter required data' do
      let(:fill_form!) do
        fill_in 'Name', with: courier_attributes[:name]
        fill_in 'Email', with: courier_attributes[:email]
      end

      it 'creates Courier successfully' do
        expect { subject }.to change { Courier.count }.by 1
        expect(page).to have_flash_message('Courier was successfully created.')
        expect(courier).to have_attributes(
          name: courier.name,
          email: courier.email
        )
      end

      it_behaves_like :render_correct_show_page
    end
  end

  describe 'update' do
    before do
      visit edit_admin_courier_path(courier_for_edit)
    end

    subject do
      fill_form!
      click_button 'Update Courier'
    end

    let(:fill_form!) do
      fill_in 'Name', with: ''
      fill_in 'Email', with: ''
    end
    let(:courier_attributes) { attributes_for(:courier) }
    let(:courier_for_edit) { create(:courier) }
    let(:courier) { Courier.last }

    it 'mappable errors should be displayed' do
      expect { subject }.not_to change { Courier.count }
      expect(page).to have_semantic_errors(count: 2)
      expect(page).to have_semantic_errors("Name can't be blank")
      expect(page).to have_semantic_errors("Email can't be blank and is invalid")
    end

    context 'when enter required data' do
      let(:fill_form!) do
        fill_in 'Name', with: courier_attributes[:name]
        fill_in 'Email', with: courier_attributes[:email]
      end

      it 'creates Courier successfully' do
        expect { subject }.not_to change { Courier.count }
        expect(page).to have_flash_message('Courier was successfully updated.')
        expect(courier).to have_attributes(
          name: courier_attributes[:name],
          email: courier_attributes[:email]
        )
      end

      it_behaves_like :render_correct_show_page
    end
  end

  describe 'destroy' do
    subject do
      page.accept_confirm do
        click_link 'Delete Courier'
      end
    end

    before do
      visit admin_courier_path(courier)
    end

    let!(:courier) { create(:courier) }

    it 'destroys courier successfully' do
      expect { subject }.to change { Courier.count }.by -1
      expect(page).to have_flash_message('Courier was successfully destroyed.')
    end
  end

end
