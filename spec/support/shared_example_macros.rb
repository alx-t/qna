module SharedExampleMacros
  def do_request(api_path, http_method, options = {})
    send http_method.to_sym, api_path, { format: :json }.merge(options)
  end
end

