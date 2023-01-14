class ApplicationController < ActionController::Base
  # CSRF対策(クロスサイトリクエストフォージェリ)
  protect_from_forgery with: :exception
  # session_helperを読み込む
  include SessionsHelper
end
