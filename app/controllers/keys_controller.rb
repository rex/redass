class KeysController < ApplicationController
  respond_to :json

  def all
    @keys = Drivers::Redis.namespace("").map { |key| { name: key } }
    respond_with @keys
  end

  def delete
    render json: { result: Drivers::Redis.delete(params[:key]) }
  end

end
