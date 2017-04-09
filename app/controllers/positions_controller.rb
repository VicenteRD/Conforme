class PositionsController < ApplicationController

  def index; end

  def show
    @position = Position.find(params[:id])

    render layout: 'show'
  end

  def new
    render layout: 'form'
  end

  def create
    position = Position.create!(position_fields)

    parent_position = Position.find(params[:parent_id])
    parent_position.add_child(position.id) if parent_position

    position.log_book.new_entry(@user.id, 'Creado', params.dig(:log, :entry))

    redirect_to position_path(position)
  end

  def edit
    @position = Position.find(params[:id])

    redirect_to '/' unless @position

    render layout: 'form'
  end

  def update
    position = Position.find(params[:id])
    redirect_to '/' && return unless position

    position.update!(position_fields)

    position.log_book.new_entry(@user.id, 'Editado', params.dig(:log, :entry))

    redirect_to position_path(position)
  end

  private

  def position_fields
    fields = params.require(:position)

    fields.permit(
      :parent_id, :name, :area,
      :functions,
      competency_ids: [], performance_ids: [],
      user_ids: []
    )
  end
end
