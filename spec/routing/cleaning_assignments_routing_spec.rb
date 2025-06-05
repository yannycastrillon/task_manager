require "rails_helper"

RSpec.describe CleaningAssignmentsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/cleaning_assignments").to route_to("cleaning_assignments#index")
    end

    it "routes to #new" do
      expect(get: "/cleaning_assignments/new").to route_to("cleaning_assignments#new")
    end

    it "routes to #show" do
      expect(get: "/cleaning_assignments/1").to route_to("cleaning_assignments#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/cleaning_assignments/1/edit").to route_to("cleaning_assignments#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/cleaning_assignments").to route_to("cleaning_assignments#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/cleaning_assignments/1").to route_to("cleaning_assignments#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/cleaning_assignments/1").to route_to("cleaning_assignments#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/cleaning_assignments/1").to route_to("cleaning_assignments#destroy", id: "1")
    end
  end
end
