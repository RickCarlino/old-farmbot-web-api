#Session controller provides a token
class Api::V1::TokensController < ApplicationController
  skip_before_action :set_user, only: [:create]

  def create
    @user = User.find_for_authentication(email: params[:email])
    if @user.valid_password?(params[:password])
      @user.ensure_authentication_token!
      render action: 'show', status: :created
    else
      head :unauthorized
    end
  end

  def destroy
    @api_user.reset_authentication_token!
    head :no_content
  end

private

  def user_params
    params.permit(:email, :password)
  end

end