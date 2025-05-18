require "rails_helper"

RSpec.describe Daisy::FormBuilderHelper, type: :helper do
  describe "form builder extensions" do
    let(:template) { ActionView::Base.new(ActionView::LookupContext.new([]), {}, nil) }
    let(:object_name) { :user }
    let(:object) { double("User", terms: true, newsletter: false, gender: "male") }
    let(:builder) { ActionView::Helpers::FormBuilder.new(object_name, object, template, {}) }

    before do
      allow(template).to receive(:daisy_checkbox).and_return("checkbox_html")
      allow(template).to receive(:daisy_radio).and_return("radio_html")
      allow(template).to receive(:daisy_label).and_return("label_html")
    end

    describe "#daisy_checkbox" do
      it "delegates to the daisy_checkbox helper with the correct object name prefix" do
        expect(template).to receive(:daisy_checkbox).with(
          name: "user[terms]",
          id: "user_terms",
          checked: true
        )

        builder.daisy_checkbox("terms")
      end

      it "allows overriding the checked state" do
        expect(template).to receive(:daisy_checkbox).with(
          name: "user[terms]",
          id: "user_terms",
          checked: false
        )

        builder.daisy_checkbox("terms", checked: false)
      end

      it "passes additional options to the component" do
        expect(template).to receive(:daisy_checkbox).with(
          name: "user[newsletter]",
          id: "user_newsletter",
          toggle: true,
          checked: false
        )

        builder.daisy_checkbox("newsletter", toggle: true)
      end
    end

    describe "#daisy_radio" do
      it "delegates to the daisy_radio helper with the correct object name prefix" do
        expect(template).to receive(:daisy_radio).with(
          name: "user[gender]",
          id: "user_gender_male",
          value: "male",
          checked: true
        )

        builder.daisy_radio("gender", value: "male")
      end

      it "sets checked to false when the object value doesn't match" do
        expect(template).to receive(:daisy_radio).with(
          name: "user[gender]",
          id: "user_gender_female",
          value: "female",
          checked: false
        )

        builder.daisy_radio("gender", value: "female")
      end

      it "allows overriding the checked state" do
        expect(template).to receive(:daisy_radio).with(
          name: "user[gender]",
          id: "user_gender_female",
          value: "female",
          checked: true
        )

        builder.daisy_radio("gender", value: "female", checked: true)
      end

      it "allows overriding the id" do
        expect(template).to receive(:daisy_radio).with(
          name: "user[gender]",
          id: "custom_id",
          value: "male",
          checked: true
        )

        builder.daisy_radio("gender", value: "male", id: "custom_id")
      end

      it "passes additional options to the component" do
        expect(template).to receive(:daisy_radio).with(
          name: "user[gender]",
          id: "user_gender_other",
          value: "other",
          checked: false,
          disabled: true
        )

        builder.daisy_radio("gender", value: "other", disabled: true)
      end

      it "renders a radio button component" do
        expect(template).to receive(:daisy_radio).with(value: "test", id: "user_gender_test", name: "user[gender]", checked: false)

        builder.daisy_radio("gender", value: "test")
      end
    end

    describe "#daisy_label" do
      it "delegates to the daisy_label helper with the correct for attribute" do
        expect(template).to receive(:daisy_label).with(
          for: "user_terms",
          title: "Terms"
        )

        builder.daisy_label("terms")
      end

      it "allows setting the title as a second parameter" do
        expect(template).to receive(:daisy_label).with(
          for: "user_terms",
          title: "Accept Terms"
        )

        builder.daisy_label("terms", "Accept Terms")
      end

      it "allows overriding the for attribute" do
        expect(template).to receive(:daisy_label).with(
          for: "custom_id",
          title: "Terms"
        )

        builder.daisy_label("terms", for: "custom_id")
      end

      it "allows overriding the title" do
        expect(template).to receive(:daisy_label).with(
          for: "user_terms",
          title: "Accept Terms and Conditions"
        )

        builder.daisy_label("terms", title: "Accept Terms and Conditions")
      end

      it "passes additional options to the component" do
        expect(template).to receive(:daisy_label).with(
          for: "user_newsletter",
          title: "Newsletter",
          required: true
        )

        builder.daisy_label("newsletter", required: true)
      end

      it "passes blocks to the component" do
        block = -> {}
        expect(template).to receive(:daisy_label).with(
          for: "user_terms",
          title: "Terms"
        ).and_yield

        builder.daisy_label("terms", &block)
      end
    end

    describe "#daisy_range" do
      it "renders a range component" do
        expect(template).to receive(:render).with(an_instance_of(Daisy::DataInput::RangeComponent))
        expect(builder).to receive(:object).and_return(nil)

        builder.daisy_range("volume")
      end

      it "sets the correct name attribute" do
        expect(builder).to receive(:object).and_return(nil)
        expect(template).to receive(:render) do |component|
          expect(component.name).to eq("user[volume]")
        end

        builder.daisy_range("volume")
      end

      it "sets the correct id attribute" do
        expect(builder).to receive(:object).and_return(nil)
        expect(template).to receive(:render) do |component|
          expect(component.id).to eq("user_volume")
        end

        builder.daisy_range("volume")
      end

      it "uses the object value when available" do
        expect(builder).to receive(:object).and_return(double(volume: 75))
        expect(template).to receive(:render) do |component|
          expect(component.value).to eq(75)
        end

        builder.daisy_range("volume")
      end
    end

    describe "#daisy_rating" do
      it "renders a rating component" do
        expect(template).to receive(:render).with(an_instance_of(Daisy::DataInput::RatingComponent))
        expect(builder).to receive(:object).and_return(nil)

        builder.daisy_rating("rating")
      end

      it "sets the correct name attribute" do
        expect(builder).to receive(:object).and_return(nil)
        expect(template).to receive(:render) do |component|
          expect(component.name).to eq("user[rating]")
        end

        builder.daisy_rating("rating")
      end

      it "sets the correct id attribute" do
        expect(builder).to receive(:object).and_return(nil)
        expect(template).to receive(:render) do |component|
          expect(component.id).to eq("user_rating")
        end

        builder.daisy_rating("rating")
      end

      it "uses the object value when available" do
        expect(builder).to receive(:object).and_return(double(rating: 4))
        expect(template).to receive(:render) do |component|
          expect(component.value).to eq(4)
        end

        builder.daisy_rating("rating")
      end
    end

    describe "#daisy_file_input" do
      it "renders a file input component" do
        expect(template).to receive(:render).with(an_instance_of(Daisy::DataInput::FileInputComponent))
        expect(builder).to receive(:object).and_return(nil)

        builder.daisy_file_input("document")
      end

      it "sets the correct name attribute" do
        expect(builder).to receive(:object).and_return(nil)
        expect(template).to receive(:render) do |component|
          expect(component.name).to eq("user[document]")
        end

        builder.daisy_file_input("document")
      end

      it "sets the correct id attribute" do
        expect(builder).to receive(:object).and_return(nil)
        expect(template).to receive(:render) do |component|
          expect(component.id).to eq("user_document")
        end

        builder.daisy_file_input("document")
      end

      it "passes additional options to the component" do
        expect(builder).to receive(:object).and_return(nil)
        expect(template).to receive(:render) do |component|
          expect(component.accept).to eq("image/*")
          expect(component.multiple).to be true
        end

        builder.daisy_file_input("avatar", accept: "image/*", multiple: true)
      end
    end

    describe "#daisy_text_input" do
      it "renders a text input component" do
        expect(template).to receive(:render).with(an_instance_of(Daisy::DataInput::TextInputComponent))
        expect(builder).to receive(:object).and_return(nil)

        builder.daisy_text_input("username")
      end

      it "sets the correct name attribute" do
        expect(builder).to receive(:object).and_return(nil)
        expect(template).to receive(:render) do |component|
          expect(component.name).to eq("user[username]")
        end

        builder.daisy_text_input("username")
      end

      it "sets the correct id attribute" do
        expect(builder).to receive(:object).and_return(nil)
        expect(template).to receive(:render) do |component|
          expect(component.id).to eq("user_username")
        end

        builder.daisy_text_input("username")
      end

      it "passes additional options to the component" do
        expect(builder).to receive(:object).and_return(nil)
        expect(template).to receive(:render) do |component|
          expect(component.type).to eq("email")
          expect(component.config_option(:placeholder)).to eq("Enter your email")
        end

        builder.daisy_text_input("email", type: "email", placeholder: "Enter your email")
      end
    end

    describe "#daisy_text_area" do
      it "renders a text area component" do
        expect(template).to receive(:render).with(an_instance_of(Daisy::DataInput::TextAreaComponent))
        expect(builder).to receive(:object).and_return(nil)

        builder.daisy_text_area("bio")
      end

      it "sets the correct name attribute" do
        expect(builder).to receive(:object).and_return(nil)
        expect(template).to receive(:render) do |component|
          expect(component.name).to eq("user[bio]")
        end

        builder.daisy_text_area("bio")
      end

      it "sets the correct id attribute" do
        expect(builder).to receive(:object).and_return(nil)
        expect(template).to receive(:render) do |component|
          expect(component.id).to eq("user_bio")
        end

        builder.daisy_text_area("bio")
      end

      it "passes additional options to the component" do
        expect(builder).to receive(:object).and_return(nil)
        expect(template).to receive(:render) do |component|
          expect(component.rows).to eq(6)
          expect(component.placeholder).to eq("Enter your biography")
        end

        builder.daisy_text_area("bio", rows: 6, placeholder: "Enter your biography")
      end
    end
  end
end
