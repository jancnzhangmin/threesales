class UserpwdsController < ApplicationController
  before_action :authenticate_role
  private
  def userpwd_params
    params.require(:userpwd).permit(:user_id, :password_digest)
  end
end
