RSpec::Matchers.define :have_flash_message do |type = :notice, flash_message|
  match do |page|
    expect(page).to have_selector(".flash_#{type}", exact_text: flash_message)
  end

  failure_message do |_page|
    "expected to find visible css \".flash_#{type}\" with exact_text #{flash_message} but there were no matches."
  end
end
