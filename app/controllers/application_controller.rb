class ApplicationController < ActionController::Base
  include Authentication

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # CanCanCan authorization
  check_authorization unless: :skip_authorization?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end

  private

  def current_ability
    @current_ability ||= Ability.new(Current.user)
  end

  def skip_authorization?
    # Skip authorization for sessions and passwords controllers (authentication related)
    controller_name.in?(%w[sessions passwords])
  end
end
