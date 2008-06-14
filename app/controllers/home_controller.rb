class HomeController < ApplicationController
  def index
    @mark = Mark.new
  end
end
