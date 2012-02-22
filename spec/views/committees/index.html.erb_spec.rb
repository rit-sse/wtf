require 'spec_helper'

describe "committees/index" do
  before(:each) do
    assign(:committees, [
      stub_model(Committee,
        :name => "Name"
      ),
      stub_model(Committee,
        :name => "Name"
      )
    ])
  end

  it "renders a list of committees" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
