# frozen_string_literal: true

class ExamplesController < ApplicationController
  def discover
    @comp = params[:id]

    unless LocoMotion::COMPONENTS.key?(@comp)
      raise ActionController::RoutingError, "Unknown component: #{@comp}"
    end

    render LocoMotion::Helpers.component_partial_path(@comp), layout: "application"
  end
end
