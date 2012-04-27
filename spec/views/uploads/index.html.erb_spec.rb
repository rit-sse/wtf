require 'spec_helper'

describe "uploads/index" do
  before(:each) do
    assign(:uploads, [
      stub_model(Upload,
        :file => "File"
      ),
      stub_model(Upload,
        :file => "File"
      )
    ])
  end

  it "renders a list of uploads" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "File".to_s, :count => 2
  end
end
