class PicturesController < ApplicationController
    def new_form
        render("pic_templates/new_form.html.erb");
    end
    def create_row
        p = Photo.new;
        
        p.source = params["the_source"];
        p.caption = params["the_caption"];
        
        p.save;
        render("pic_templates/create_row.html.erb");
    end
    def index
        @list_photos = Photo.all;
        render("pic_templates/index.html.erb");
    end
    def show
        @pic = Photo.find(params["the_id"]);
        
        render("pic_templates/show.html.erb");
    end
    def edit_form
        render("pic_templates/edit_form.html.erb");
    end
    def update_row
        render("pic_templates/update_row.html.erb");
    end
    def destroy_row
        Photo.find(params["toast_id"]).destroy;
        render("pic_templates/destroy_row.html.erb");
    end
end