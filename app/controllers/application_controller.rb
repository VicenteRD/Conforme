class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :ensure_login

  include DatesHelper

  def ensure_login
    @user = Person::User.find(session[:id]) if session[:id]

    redirect_to('/login', status: 302) unless @user
  end

  def valid_login?
    session[:id]
  end

  protected

  def redirect_to_dashboard
    redirect_to '/'
  end

  def current_user_id
    @user.id
  end

  def log_body
    params.dig(:log, :body)
  end

  def references_unsafe_hash
    params[:references].to_unsafe_h if params[:references]
  end

  def create_references(object, reference_ids, base_id = '')
    object.set_references_from_hash(reference_ids, base_id) if reference_ids
  end

  def add_attachments(object, uploads)
    return unless uploads
    klass = object.class
    return unless klass < Describable && klass < Mongoid::Document

    processed_uploads = ul_files(uploads)

    object.add_to_set(
      attachment_ids: processed_uploads.map { |upload| upload.id.to_s }
    )

    processed_uploads.each do |upload|
      upload.add_as_attachment_to(klass.name => [object.id])
    end
  end

  #
  # Creates documents of the UploadedFile class given an array of documents
  #
  # DEPRECATED - Use add_attachments
  def upload_files(uploads)
    ul_ids = []
    uploads.each do |upload|
      next unless upload
      uploaded = UploadedFile
                 .where(upload_file_name: upload.original_filename)
                 .first_or_create!(upload: upload)
      ul_ids.append(uploaded.id.to_s)
    end

    ul_ids
  end

  def remove_attachments(class_name, element, removal_ids)
    element.attachment_ids -= removal_ids
    element.save!

    UploadedFile.find(removal_ids).each do |attachment|
      attachment.attached_to[class_name] -= [element.id]

      attachment.attached_to.delete(class_name) if
          attachment.attached_to[class_name].empty?

      attachment.save!
    end

  end

  def parse_date(date_string, time = true)
    parse_datetime(date_string, time)
  end

  def parse_percentage(hash, key, dec_percentage)
    hash[key] = dec_percentage.to_f / 100.0 if dec_percentage
  end

  private

  def ul_files(uploads)
    uploads.map { |upload|
      UploadedFile.where(
          upload_file_name: upload.original_filename
      ).first_or_create!(
          upload: upload
      )
    }
  end
end
