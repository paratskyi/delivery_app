RSpec.shared_examples :create_record_with_correct_attributes do
  let(:record_attributes) { nil }

  it "creates #{described_class} with correct attributes" do
    expect { subject }.to change { described_class.count }.by(1)
    expect(subject.errors.messages).to be_empty
    expect(described_class.last).to have_attributes(record_attributes)
  end
end
