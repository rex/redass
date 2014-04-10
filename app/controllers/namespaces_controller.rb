class NamespacesController < ApplicationController
  respond_to :json

  def list
    @namespaces = Utils::Redis::Namespace.details
    respond_with @namespaces
  end

  def view
    @keys = Utils::Redis::Namespace.details params[:namespace]
    respond_with @keys.reject { |k| k.empty? }
  end

  def delete
    namespace = params[:namespace]

    if Utils::Redis::Namespace.delete(namespace)
      render json: { result: 1 }
    else
      render json: { result: 0 }
    end
  end

end
