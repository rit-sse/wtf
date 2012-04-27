require 'spec_helper'

describe "events/new.html.erb" do
  before(:each) do
    assign(:event, stub_model(Event,
      :name => "MyString",
      :price => 1.5
    ).as_new_record)
  end

  it "renders new event form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_events_path, :method => "post" do
      assert_select "input#event_name", :name => "event[name]"
      assert_select "input#event_price", :name => "event[price]"
    end
  end
end
