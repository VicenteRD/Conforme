class UploadedFilesController < ApplicationController

  def create
    UploadedFile.create!(params.require(:uploaded_file).permit(:upload))
  end
end
