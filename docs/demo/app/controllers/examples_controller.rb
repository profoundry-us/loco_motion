class ExamplesController < ApplicationController

  def discover
    @comp = "#{params[:framework]}/#{params[:category]}/#{params[:component]}"
    render "examples/#{@comp}", layout: true

    #render html: params.inspect, layout: true
  end

end
