require 'spec_helper'

describe "uploads/show" do
  before(:each) do
    @upload = assign(:upload, stub_model(Upload,
      :file => "File"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/File/)
  end
end
