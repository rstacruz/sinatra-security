module Sinatra
  module Security
    module Helpers
      def redirect_to_stored
        if return_to = session[:return_to]
          session[:return_to] = nil
          redirect return_to
        else
          redirect "/"
        end
      end

      def authenticate(params)
        if user = User.authenticate(params[:username], params[:password])
          session[:user] = user.id
        end
      end

      def require_login
        if logged_in?
          return true
        else
          session[:return_to] = request.fullpath
          redirect "/login"
          return false
        end
      end

      def current_user
        @current_user ||= User[session[:user]] if session[:user]
      end

      def logged_in?
        !! current_user
      end

      def ensure_current_user(user)
        halt 404 unless user == current_user
      end
    end
  end
end