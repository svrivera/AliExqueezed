class ErrorsController < ApplicationController
  def not_found
    render json: {'Error': 'Bad URL'}, status: 400
  end

  def server_error
    render json: {'Error': 'Server Error'}, status: 500
  end
end
