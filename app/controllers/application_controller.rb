class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # session_helperを読み込む
  include SessionsHelper
end
