RSpec.shared_examples :does_not_create_record do
  let(:errors) { nil }

  it "does not creates #{described_class}" do
    expect { subject }.not_to change { described_class.count }
    expect(subject.errors.full_messages).to match_array(errors)
  end
end
