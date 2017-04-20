class UploadedFilesController < ApplicationController
  def index
    render layout: 'table'
  end

  def show
    if (@file = UploadedFile.find(params[:id]))
      render layout: 'show'
    else
      redirect_to '/'
    end
  end

  def new
    render layout: 'form'
  end

  def create
    uploaded_file = UploadedFile.create!(params.require(:uploaded_file).permit(:upload))

    uploaded_file.add_as_attachment_to(params[:references].to_unsafe_h)
  end
end
