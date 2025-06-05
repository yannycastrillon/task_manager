require 'rails_helper'

RSpec.describe "cleaning_assignments/show", type: :view do
  before(:each) do
    assign(:cleaning_assignment, CleaningAssignment.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
