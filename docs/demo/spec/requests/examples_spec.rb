# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Examples", type: :request do
  describe "GET /examples/:id" do
    context "when the component id is not registered" do
      it "returns a 404 instead of raising a NoMethodError" do
        get "/examples/Totally::MadeUpComponent"

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
