class UploadedFilesController < ApplicationController

  def create
    UploadedFile.create!(params.require(:uploaded_file).permit(:upload))
  end

  def create_multi
    puts 'CREATING MULTIPLE UPLOADS', params.inspect
  end
end
