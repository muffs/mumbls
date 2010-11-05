require 'spec_helper'

describe "housings/edit.html.haml" do
  before(:each) do
    @housing = assign(:housing, stub_model(Housing,
      :new_record? => false,
      :title => "MyString",
      :description => "MyText",
      :address => "MyString",
      :price => 1
    ))
  end

  it "renders the edit housing form" do
    render

    rendered.should have_selector("form", :action => housing_path(@housing), :method => "post") do |form|
      form.should have_selector("input#housing_title", :name => "housing[title]")
      form.should have_selector("textarea#housing_description", :name => "housing[description]")
      form.should have_selector("input#housing_address", :name => "housing[address]")
      form.should have_selector("input#housing_price", :name => "housing[price]")
    end
  end
end
