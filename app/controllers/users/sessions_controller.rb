class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    render json: {
      status: {
        code: 200,
        message: "Logged in successfully"
      },
      data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
    }
  end

  def respond_to_on_destroy
  if request.headers['Authorization'].present?
    jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1], Rails.application.credentials.fetch(:secret_key_base)).first
    current_user = User.find(jwt_payload['sub'])
    if current_user.present?
      sign_out(current_user)
      render json: { status: { code: 200, message: "Signed out successfully" } }
    else
      render json: { status: { code: 401, message: "Couldn't find an active session" } }, status: :unauthorized
    end
  else
    render json: { status: { code: 401, message: "No Authorization header present" } }, status: :unauthorized
  end
end

end
