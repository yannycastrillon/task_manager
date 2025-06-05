require 'rails_helper'

RSpec.describe "cleaning_assignments/index", type: :view do
  before(:each) do
    assign(:cleaning_assignments, [
      CleaningAssignment.create!(),
      CleaningAssignment.create!()
    ])
  end

  it "renders a list of cleaning_assignments" do
    render
    cell_selector = 'div>p'
  end
end
