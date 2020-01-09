class ErrorsController < ApplicationController
  def error_404
    render 'errors/404'
  end
end
