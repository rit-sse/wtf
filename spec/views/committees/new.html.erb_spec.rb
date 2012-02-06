require 'spec_helper'

describe "committees/new" do
  before(:each) do
    assign(:committee, stub_model(Committee,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new committee form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => committees_path, :method => "post" do
      assert_select "input#committee_name", :name => "committee[name]"
    end
  end
end
