require 'spec_helper'

describe "Committees" do
  describe "GET /committees" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get committees_path
      response.status.should be(200)
    end
  end
end
