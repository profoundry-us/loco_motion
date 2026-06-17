# frozen_string_literal: true

# Demo-only controller backing the Modal "Global Modal (Turbo Frame)" example.
#
# `edit` streams an edit form into the modal's `<turbo-frame>` (the
# `loco-modal` controller opens the dialog when the frame loads). `update`
# pretends to save and returns `204 No Content` so Turbo fires `turbo:submit-end`
# — which the form is wired to close on — without replacing the frame.
class ModalContactsController < ApplicationController
  CONTACTS = {
    "1" => "Alice Anderson",
    "2" => "Ben Brooks",
    "3" => "Cara Castillo"
  }.freeze

  def edit
    @id = params[:id]
    @name = CONTACTS.fetch(@id, "Unknown Contact")

    render layout: false
  end

  def update
    head :no_content
  end
end
