RSpec::Matchers.define :have_semantic_errors do |error_message|
  match do |page|
    expect(page).to have_selector('ul.errors > li', exact_text: error_message)
  end

  failure_message do |page|
    "expected to find visible css \"ul.errors > li\" with exact_text #{error_message} but there were no matches."
  end
end
