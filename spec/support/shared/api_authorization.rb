shared_examples_for "API Authenticable" do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      do_request http_method, api_path
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      do_request(http_method, api_path, {access_token: '1234'})
      expect(response.status).to eq 401
    end
  end
end

