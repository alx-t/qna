module SharedExampleMacros
  def do_request(http_method, api_path, options = {})
    send http_method.to_sym, api_path, { format: :json }.merge(options)
  end
end

