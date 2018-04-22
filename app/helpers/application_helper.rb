#require 'Base64'
require 'openssl'
# para HMAC-SHA1 en base 64 se utilizó código del siguiente link:
# https://gist.github.com/bentonporter/2891463

module ApplicationHelper

  def get_data(method, ids)
    return method + ids
  end

  def create_Hash(key, data)
    return Base64.encode64(OpenSSL::HMAC.digest('sha1', key, data))
  end

  def make_request(url, hash)
    response = HTTParty.get(url,
        {
            headers:
                {
                "Authorization" => "INTEGRACION grupo2:" + hash,
                "Content-Type" => "application/json"
                }
        }
        )
  end

  def get_almacenes()
    key = 's.0t9sx$iHdfsfd'
    url = 'https://integracion-2018-dev.herokuapp.com/bodega/almacenes'

    data = get_data('GET', '')
    # lo anterior se imprime al llamar <% get_almacenes()%> (acutalmente está en
    # la view del home)
    p make_request(url, create_Hash(key, data))
  end

  def get_products(almacen_id, sku)
    key = 's.0t9sx$iHdfsfd'
    url = 'https://integracion-2018-dev.herokuapp.com/bodega/stock?almacenId=' + almacen_id + '&sku=' + sku

    data = get_data('GET', almacen_id + sku)

    p make_request(url, create_Hash(key, data))

  end

  def get_stock(almacen_id)
    key = 's.0t9sx$iHdfsfd'
    url = 'https://integracion-2018-dev.herokuapp.com/bodega/skusWithStock?almacenId=' + almacen_id

    data = get_data('GET', almacen_id)
    p make_request(url, create_Hash(key, data))
  end

  def despacho(productId, direccion, precio, oc)
    key = 's.0t9sx$iHdfsfd'
    url = 'https://integracion-2018-dev.herokuapp.com/bodega/stock'

    data = get_data('DELETE', productId + direccion + precio + oc)
    p make_request(url, create_Hash(key, data))
  end
end
