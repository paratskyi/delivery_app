RSpec.shared_examples :update_record_with_correct_attributes do
  let(:record_attributes) { nil }

  it "updates #{described_class} with correct attributes" do
    expect { subject }.not_to change { described_class.count }
    expect(record.errors.messages).to be_empty
    expect(record.reload).to have_attributes(record_attributes)
  end
end
