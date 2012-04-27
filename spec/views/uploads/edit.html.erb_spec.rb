require 'spec_helper'

describe "uploads/edit" do
  before(:each) do
    @upload = assign(:upload, stub_model(Upload,
      :file => "MyString"
    ))
  end

  it "renders the edit upload form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => uploads_path(@upload), :method => "post" do
      assert_select "input#upload_file", :name => "upload[file]"
    end
  end
end
