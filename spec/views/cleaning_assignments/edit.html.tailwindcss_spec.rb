require 'rails_helper'

RSpec.describe "cleaning_assignments/edit", type: :view do
  let(:cleaning_assignment) {
    CleaningAssignment.create!()
  }

  before(:each) do
    assign(:cleaning_assignment, cleaning_assignment)
  end

  it "renders the edit cleaning_assignment form" do
    render

    assert_select "form[action=?][method=?]", cleaning_assignment_path(cleaning_assignment), "post" do
    end
  end
end
