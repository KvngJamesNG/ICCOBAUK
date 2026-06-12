class InfoPagesController < ApplicationController
  def show
    @info_page = InfoPage.published.find_by!(slug: params[:slug])
  end
end
