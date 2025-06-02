require 'rails_helper'

RSpec.describe "tasks/index", type: :view do
  before(:each) do
    assign(:tasks, [
      Task.create!(
        name: "Name",
        description: "MyText",
        priority: "Priority",
        status: "Status"
      ),
      Task.create!(
        name: "Name",
        description: "MyText",
        priority: "Priority",
        status: "Status"
      )
    ])
  end

  it "renders a list of tasks" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Priority".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Status".to_s), count: 2
  end
end
