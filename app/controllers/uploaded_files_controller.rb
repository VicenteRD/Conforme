class UploadedFilesController < ApplicationController

  def index
    render layout: 'table'
  end

  def new
    render layout: 'form'
  end

  def create
    UploadedFile.create!(params.require(:uploaded_file).permit(:upload))
  end
end
