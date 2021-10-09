RSpec::Matchers.define :have_flash_message do |flash_message|
  match do |page|
    expect(page).to have_selector('.flash_notice', exact_text: flash_message)
  end

  failure_message do |_page|
    "expected to find visible css \".flash_notice\" with exact_text #{flash_message} but there were no matches."
  end
end
