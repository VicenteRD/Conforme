class UsersController < ApplicationController
  def index
    render layout: 'table'
  end

  def show
    @person = Person::User.find(params[:id])
    redirect_to_dashboard && return unless @person

    render layout: 'profile'
  end

  def new
    render layout: 'form'
  end

  def edit
    @person = Person::User.find(params[:id])
    redirect_to_dashboard unless @person

    render layout: 'form'
  end

  def create
    redirect_to_dashboard && return unless confirm_password

    user = Person::User.create!(user_fields)
    redirect_to_dashboard && return unless user

    create_references(user, references_unsafe_hash)
    add_attachments(user, params.dig(:employee, :attachments))

    redirect_to user_path(user)
  end

  def update
    redirect_to_dashboard && return unless confirm_password
    user = Person::User.find(params[:id])
    redirect_to_dashboard && return unless user

    user.update!(user_fields)
    log_edited(user)

    create_references(user, references_unsafe_hash)

    redirect_to user_path(user)
  end

  def edit_attachments
    employee = Person::User.find(params.dig(:attachments, :element_id))
    return unless employee

    additions = params.dig(:attachments, :additions)
    removal_ids = params.dig(:attachments, :removal_ids)

    add_attachments(employee, additions) if additions
    remove_attachments(employee.class.name, employee, removal_ids) if
        removal_ids

    redirect_to employee
  end

  private

  def confirm_password
    params.dig(:raw, :password_confirm) == params.dig(:employee, :password)
  end

  def user_fields
    fields = params.require(:employee)

    fields[:dob] = parse_date(params.dig(:raw, :dob), false)

    fields.permit(
      :rut, :dob,
      :name, :l_name1, :l_name2,
      :email, :phone, :address,
      :contract_type, :password,
      position_ids: []
    )
  end
end
