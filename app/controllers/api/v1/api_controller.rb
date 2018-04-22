include ApplicationHelper

# EL TOKEN DEL METODO PRIVADO DE LA API ES: 'xSzmqDTZNceaVmopIC495QAMPdM='
# Fue creado con create_Hash('Grupo2_ElMejor', 'Den mas plazo por favor!')
# NOTA: se eliminó un \n al final del password para evitar problemas de string

class Api::V1::ApiController < ActionController::API
  def stock
    response = []
    almacenes = get_almacenes().parsed_response
    almacenes_stocks = Hash.new
    almacenes.each do |almacen|
      almacenes_stocks[almacen['_id']] = {tipo: almacen.key(true), available: get_stock(almacen['_id']).parsed_response}
    end
    almacenes_stocks.each do |key,value|
      value[:available].each do |product|
        if not({'sku': product['_id']}.in?(response))
          response.push({'sku': product['_id']})
        end
      end
    end
    response.each do |product|
      product['available'] = 0
    end
    # Hasta acá se creo la lista 'response' que contiene un hash para cada sku
    # que contiene el sku correspondiente y available seteado en 0
    # Para crear esta lista fue consultada la API Bodega proporcionada por el profesor
    almacenes_stocks.each do |id_almacen, skus_y_availables|
      skus_y_availables[:available].each do |sku_y_available|
        response.each do |product|
          if sku_y_available['_id'] == product[:sku]
            product['available'] += sku_y_available['total']
          end
        end
        sku_y_available.each do |jeje|
        end
      end
    end
    # A traves de estas iteraciones se fue sumando para cada sku de la lista 'response'
    # la cantidad total contenida en cada almacen, para ello fue necesario recorrer
    # los almacenes e ir buscando los skus que estaban en cada almacen y actulizar
    # el valor available de la lista 'response'
    render json: response, status: 200
  end

  def stock_private
    if bearer_token == "'xSzmqDTZNceaVmopIC495QAMPdM='"
      stock()
    else
      render json: {'Unauthorized': 'Bad Token'}, status: 401
    end

  end

  def bearer_token
    pattern = /^Bearer /
    header  = request.headers['Authorization']
    header.gsub(pattern, '') if header && header.match(pattern)
  end
end
