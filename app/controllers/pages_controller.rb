class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home
  def home
    @no_navbar = true
    @date = Date.today
  end
end
