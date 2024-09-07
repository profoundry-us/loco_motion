class ExamplesController < ApplicationController

  def discover
    render "examples/#{params[:framework]}/#{params[:category]}/#{params[:component]}", layout: true

    #render html: params.inspect, layout: true
  end

end
