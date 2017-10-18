class UserpwdsController < ApplicationController

  private
  def userpwd_params
    params.require(:userpwd).permit(:user_id, :password_digest)
  end
end
