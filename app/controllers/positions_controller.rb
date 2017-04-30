class PositionsController < ApplicationController
  def index; end

  def show
    @position = Position.find(params[:id])

    render layout: 'show'
  end

  def new
    render layout: 'form'
  end

  def edit
    @position = Position.find(params[:id])
    redirect_to_dashboard unless @position

    render layout: 'form'
  end

  def create
    position = Position.create!(position_fields)
    log_created(position)

    parent_position = Position.find(position.parent_id)
    parent_position.add_child(position.id) if parent_position

    create_references(position, references_unsafe_hash)
    add_attachments(position, params.dig(:position, :attachments))

    redirect_to position
  end

  def update
    position = Position.find(params[:id])
    redirect_to_dashboard && return unless position

    old_parent_id = position.parent_id

    position.update!(position_fields)
    log_edited(position)

    update_parent_position(position, old_parent_id) if
        position.parent_id != old_parent_id

    create_references(position, references_unsafe_hash)

    redirect_to position
  end

  def edit_attachments
    position = Position.find(params.dig(:attachments, :element_id))
    return unless position

    additions = params.dig(:attachments, :additions)
    removal_ids = params.dig(:attachments, :removal_ids)

    add_attachments(position, additions) if additions
    remove_attachments(position.class.name, position, removal_ids) if
        removal_ids

    redirect_to position
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

  def update_parent_position(position, old_parent_id)
    old_parent = Position.find(old_parent_id)
    new_parent = Position.find(position.parent_id)

    old_parent.remove_child(position.id)
    new_parent.add_child(position.id)
  end
end
