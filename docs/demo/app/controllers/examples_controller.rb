class ExamplesController < ApplicationController

  def discover
    if params[:category].present?
      @comp = "#{params[:framework]}/#{params[:category]}/#{params[:component]}"
    else
      @comp = "#{params[:framework]}/#{params[:component]}"
    end

    render "examples/#{@comp.pluralize}", layout: "application"
  end

end
