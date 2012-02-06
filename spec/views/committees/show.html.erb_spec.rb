require 'spec_helper'

describe "committees/show" do
  before(:each) do
    @committee = assign(:committee, stub_model(Committee,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
