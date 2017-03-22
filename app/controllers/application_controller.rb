class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :ensure_login

  def ensure_login
    if session[:id]
      @user = Person::User.find(session[:id])
    end

    unless @user
      redirect_to '/login', status: 302
    end
  end

  def valid_login?
    session[:id]
  end

  protected

  def create_references(object, reference_ids)
    object.set_references_from_hash(reference_ids)
  end

  #
  # Creates documents of the UploadedFile class given an array of documents
  #
  def upload_files(uploads)
    ul_ids = []
    uploads.each { |upload|
      if upload
        uploaded = UploadedFile.where(upload_file_name: upload.original_filename)
                       .first_or_create!(upload: upload)
        ul_ids.append(uploaded.id.to_s)
      end
    }

    ul_ids
  end
end
