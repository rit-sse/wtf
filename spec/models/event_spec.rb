require 'spec_helper'

describe Event do
  it "requires a name, short name, location and committee" do
    committee = Committee.new
    
    event = Event.new
    event.name = "Name"
    event.short_name = "Short Name"
    event.location = "Location"
    event.committee = committee

    expect(event.valid?).to eq(true)

    event.name = nil
    expect(event.valid?).to eq(false)
    event.name = "Name"

    

    event.location = nil
    expect(event.valid?).to eq(false)
    event.location = "Location"

    event.committee = nil
    expect(event.valid?).to eq(false)
    event.committee = committee

    event.short_name = nil
    expect(event.valid?).to eq(false)
    event.short_name = "Short Name"

  end

  it "requires short names to be < 25 chars" do
    committee = Committee.new

    event = Event.new
    event.name = "Name"
    event.short_name = "a"
    event.location = "Location"
    event.committee = committee

    expect(event.valid?).to eq(true)
    event.short_name = "a" * 24
    expect(event.valid?).to eq(true)
    event.short_name = "a" * 25
    expect(event.valid?).to eq(true)
    event.short_name = "a" * 26
    expect(event.valid?).to eq(false)
    event.short_name = "a" * 27
    expect(event.valid?).to eq(false)
  end
end
