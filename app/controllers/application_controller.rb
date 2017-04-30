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
    if object.class < Referable
      reference_ids ||= {}
      object.set_references_from_hash(reference_ids, base_id.to_s)
    else
      puts 'Tried to create references for a non-referable object'
    end
  end

  def add_attachments(object, uploads, base_id = '')
    klass = object.class
    return unless uploads && klass < Describable && klass < Mongoid::Document

    processed_uploads = ul_files(uploads)

    object.add_to_set(
      attachment_ids: processed_uploads.map { |upload| upload.id.to_s }
    )

    processed_uploads.each do |upload|
      upload.add_as_attachment_to(
        klass.name => [compound_id(base_id.to_s, object.id)]
      )
    end
  end

  def remove_attachments(class_name, element, removal_ids, base_id = '')
    element.attachment_ids -= removal_ids
    element.save!

    element_id = compound_id(base_id.to_s, object.id)
    UploadedFile.find(removal_ids).each do |attachment|
      attachment.remove_attached_to(class_name, [element_id])
    end
  end

  def log_created(object)
    object.log_book.new_entry(current_user_id, 'Creado', log_body)
  end

  def log_edited(object)
    object.log_book.new_entry(current_user_id, 'Editado', log_body)
  end

  def parse_date(date_string, time = true)
    parse_datetime(date_string, time)
  end

  def parse_percentage(hash, key, dec_percentage)
    hash[key] = dec_percentage.to_f / 100.0 if dec_percentage
  end

  private

  def ul_files(uploads)
    uploads.map do |upload|
      UploadedFile.where(
        upload_file_name: upload.original_filename
      ).first_or_create!(
        upload: upload
      )
    end
  end

  def compound_id(base_id, object_id)
    base_id + (base_id.empty? ? '' : '#') + object_id
  end
end
