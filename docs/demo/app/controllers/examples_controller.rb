# frozen_string_literal: true

class ExamplesController < ApplicationController
  def discover
    @comp = params[:id]

    unless LocoMotion::COMPONENTS.key?(@comp)
      raise ActionController::RoutingError, "Unknown component: #{@comp}"
    end

    posthog_capture("component_example_viewed", {
                      component_name: @comp,
                      component_group: LocoMotion::COMPONENTS.dig(@comp, :group)
                    })

    render LocoMotion::Helpers.component_partial_path(@comp), layout: "application"
  end
end
