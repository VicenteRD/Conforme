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

  def create
    redirect_to_dashboard && return unless confirm_password

    user = Person::User.create!(user_fields)
    redirect_to_dashboard && return unless user

    redirect_to user_path(user)
  end

  def edit
    @person = Person::User.find(params[:id])

    redirect_to '/' unless @person

    render layout: 'form'
  end

  def update
    redirect_to_dashboard && return unless confirm_password

    user = Person::User.find(params[:id])
    redirect_to_dashboard && return unless user

    user.update!(user_fields)

    redirect_to user_path(user)
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
