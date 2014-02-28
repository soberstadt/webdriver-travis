require "spec_helper"

describe "Google" do
  before { goto "http://google.com" }

  it "has search box" do
    text_field(:name => "q").should be_present
  end

  it "allows to search" do
    text_field(:name => "q").set "watir"
    button(:id => "gbqfb").click
    results = div(:id => "ires")
    results.should be_present.within(2)
    results.lis(:class => "g").map(&:text).should be_any { |text| text =~ /watir/ }
    results.should be_present.during(1)
  end
end