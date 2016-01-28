require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do

    it_behaves_like "API Authenticable" do
      let(:api_path) { "/api/v1/profiles/me" }
    end

    context 'authorized' do
      let(:me) { create :user }
      let(:access_token) { create :access_token, resource_owner_id: me.id }

      before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encypted_password).each do |attr|
        it "does not contains #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  describe 'GET /index' do

    it_behaves_like "API Authenticable" do
      let(:api_path) { "/api/v1/profiles" }
    end

    context 'authorized' do
      let(:me) { create :user }
      let!(:users) { create_list :user, 3 }
      let(:access_token) { create :access_token, resource_owner_id: me.id }

      before { get '/api/v1/profiles', format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'contains users' do
        expect(response.body).to be_json_eql(users.to_json).at_path('profiles')
      end

      it 'not contains me' do
        expect(response.body).to_not include_json me.to_json
      end
    end
  end
end

