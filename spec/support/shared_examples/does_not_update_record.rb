RSpec.shared_examples :does_not_update_record do
  let(:errors) { nil }

  it "does not updates #{described_class}" do
    expect { subject }.not_to change { described_class.count }
    expect(record.errors.full_messages).to match_array(errors)
  end
end
