class PicturesController < ApplicationController
  def new_form
    render("pic_templates/new_form.html.erb")
  end

  def create_row
    p = Photo.new

    p.source = params[:the_source]
    p.caption = params[:the_caption]

    p.save

    @current_count = Photo.count

    render("pic_templates/create_row.html.erb")
  end

  def index
    @list_of_photos = Photo.order(:created_at => :desc)

    render("pic_templates/index.html.erb")
  end

  def show
    @photo = Photo.find(params[:an_id])

    render("pic_templates/show.html.erb")
  end

  def edit_form
    @photo = Photo.find(params[:some_id])

    render("pic_templates/edit_form.html.erb")
  end

  def update_row
    p = Photo.find(params[:the_id])

    p.source = params[:the_source]
    p.caption = params[:the_caption]

    p.save

    @the_id = p.id

    render("pic_templates/update_row.html.erb")
  end

  def destroy_row
    p = Photo.find(params[:toast_id])

    p.destroy

    @remaining_count = Photo.count

    render("pic_templates/destroy_row.html.erb")
  end
end
