require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/cleaning_assignments", type: :request do
  # This should return the minimal set of attributes required to create a valid
  # CleaningAssignment. As you add validations to CleaningAssignment, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      CleaningAssignment.create! valid_attributes
      get cleaning_assignments_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      cleaning_assignment = CleaningAssignment.create! valid_attributes
      get cleaning_assignment_url(cleaning_assignment)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_cleaning_assignment_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      cleaning_assignment = CleaningAssignment.create! valid_attributes
      get edit_cleaning_assignment_url(cleaning_assignment)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new CleaningAssignment" do
        expect {
          post cleaning_assignments_url, params: { cleaning_assignment: valid_attributes }
        }.to change(CleaningAssignment, :count).by(1)
      end

      it "redirects to the created cleaning_assignment" do
        post cleaning_assignments_url, params: { cleaning_assignment: valid_attributes }
        expect(response).to redirect_to(cleaning_assignment_url(CleaningAssignment.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new CleaningAssignment" do
        expect {
          post cleaning_assignments_url, params: { cleaning_assignment: invalid_attributes }
        }.to change(CleaningAssignment, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post cleaning_assignments_url, params: { cleaning_assignment: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested cleaning_assignment" do
        cleaning_assignment = CleaningAssignment.create! valid_attributes
        patch cleaning_assignment_url(cleaning_assignment), params: { cleaning_assignment: new_attributes }
        cleaning_assignment.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the cleaning_assignment" do
        cleaning_assignment = CleaningAssignment.create! valid_attributes
        patch cleaning_assignment_url(cleaning_assignment), params: { cleaning_assignment: new_attributes }
        cleaning_assignment.reload
        expect(response).to redirect_to(cleaning_assignment_url(cleaning_assignment))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        cleaning_assignment = CleaningAssignment.create! valid_attributes
        patch cleaning_assignment_url(cleaning_assignment), params: { cleaning_assignment: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested cleaning_assignment" do
      cleaning_assignment = CleaningAssignment.create! valid_attributes
      expect {
        delete cleaning_assignment_url(cleaning_assignment)
      }.to change(CleaningAssignment, :count).by(-1)
    end

    it "redirects to the cleaning_assignments list" do
      cleaning_assignment = CleaningAssignment.create! valid_attributes
      delete cleaning_assignment_url(cleaning_assignment)
      expect(response).to redirect_to(cleaning_assignments_url)
    end
  end
end
