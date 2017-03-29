class UsersController < ApplicationController

  def index
    render layout: 'table'
  end

  def show
    if (@person = Person::User.find(params[:id]))
      render layout: 'profile'
    else
      redirect_to '/'
    end
  end

  def new
    render layout: 'form'
  end

  def create
    redirect_to '/' && return unless confirm_password

    user = Person::User.create!(user_fields)

    redirect_to user_path(user)
  end

  def edit
    @person = Person::User.find(params[:id])

    redirect_to '/' unless @person

    render layout: 'form'
  end

  def update
    redirect_to '/' && return unless confirm_password

    user = Person::User.find(params[:id])
    redirect_to '/' unless user

    user.update!(user_fields)

    redirect_to user_path(user)
  end

  private

  def confirm_password
    params.dig(:raw, :password_confirm) == params.dig(:employee, :password)
  end

  def user_fields
    fields = params.require(:employee)
    fields[:dob] = parse_date(params.dig(:raw, :dob))
    fields.permit(
      :rut, :dob,
      :name, :l_name1, :l_name2,
      :email, :phone, :address,
      :contract_type, :password
    )
  end
end
