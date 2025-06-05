require 'rails_helper'

RSpec.describe "cleaning_assignments/new", type: :view do
  before(:each) do
    assign(:cleaning_assignment, CleaningAssignment.new())
  end

  it "renders new cleaning_assignment form" do
    render

    assert_select "form[action=?][method=?]", cleaning_assignments_path, "post" do
    end
  end
end
