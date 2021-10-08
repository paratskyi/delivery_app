RSpec::Matchers.define :have_attribute_row do |label, options = {}|
  match do |page|
    expect(page).to have_selector("tr.row-#{label.downcase} > td", options)
  end

  failure_message do |page|
    "expected to find visible css \"tr.row-#{label.downcase} > td\" with #{options} but there were no matches."
  end
end

RSpec::Matchers.define :have_attribute_cell do |label, options = {}|
  match do |page|
    expect(page).to have_selector("td.col-#{label.downcase}", options)
  end

  failure_message do |page|
    "expected to find visible css \"td.col-#{label.downcase}\" with #{options} but there were no matches."
  end
end
