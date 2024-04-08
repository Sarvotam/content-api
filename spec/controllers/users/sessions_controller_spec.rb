require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  describe 'POST #create' do
    context 'with valid credentials' do
      let!(:user) { User.create(email: 'test@example.com', password: 'password') }

      before do
        request.env['devise.mapping'] = Devise.mappings[:user]
        post :create, params: { user: { email: 'test@example.com', password: 'password' } }
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns a JSON response with success message' do
        json_response = JSON.parse(response.body)
        expect(json_response['status']['code']).to eq(200)
        expect(json_response['status']['message']).to eq('Logged in successfully')
      end
    end

    context 'with invalid credentials' do
      before do
        request.env['devise.mapping'] = Devise.mappings[:user]
        post :create, params: { user: { email: 'test@example.com', password: 'invalid_password' } }
      end

      it 'returns an unauthorized response' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is signed in' do
      let!(:user) { User.create(email: 'test@example.com', password: 'password') }
      let(:token) { 'valid_jwt_token' } # Define a valid JWT token for testing purposes

      before do
        allow(JsonWebToken).to receive(:encode).and_return(token) # Stub the encode method to return the predefined token
        request.headers['Authorization'] = "Bearer #{token}"
        delete :destroy
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns a JSON response with success message' do
        json_response = JSON.parse(response.body)
        expect(json_response['status']['code']).to eq(200)
        expect(json_response['status']['message']).to eq('Signed out successfully')
      end
    end
  end
end
