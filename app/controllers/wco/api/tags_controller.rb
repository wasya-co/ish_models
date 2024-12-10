
class Wco::Api::TagsController < Wco::ApiController

  def index
    authorize! :index, Wco::Tag
    @tags = Wco::Tag.all()
  end

end
