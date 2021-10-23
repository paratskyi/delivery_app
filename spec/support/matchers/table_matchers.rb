RSpec::Matchers.define :have_attribute_row do |label, options = {}|
  match do |page|
    expect(page).to have_selector("tr.row-#{label.downcase.gsub(' ', '_')} > td", options)
  end

  failure_message do |_page|
    "expected to find visible css \"tr.row-#{label.downcase.gsub(' ', '_')} > td\" with #{options} but there were no matches."
  end
end

RSpec::Matchers.define :have_attribute_cell do |label, options = {}|
  match do |page|
    expect(page).to have_selector("td.col-#{label.downcase.gsub(' ', '_')}", options)
  end

  failure_message do |_page|
    "expected to find visible css \"td.col-#{label.downcase.gsub(' ', '_')}\" with #{options} but there were no matches."
  end
end
