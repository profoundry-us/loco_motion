class ExamplesController < ApplicationController

  def discover
    @comp = params[:id]

    render LocoMotion::Helpers.component_example_path(@comp), layout: "application"
  end

end
