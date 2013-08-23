module ReconDatabase
  module Helpers
    def current_user
      User.where(id: session[:user_id]).first
    end

    def authenticate!
      unless current_user
        redirect "/"
      end
    end
  end
end
