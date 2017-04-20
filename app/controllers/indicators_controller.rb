class IndicatorsController < ApplicationController
  def index
    render layout: 'table'
  end

  def show
    @indicator = Indicator.find(params[:id])
    redirect_to_dashboard unless @indicator

    render layout: 'show'
  end

  def new
    render layout: 'form'
  end

  def edit
    @indicator = Indicator.find(params[:id])
    redirect_to_dashboard unless @indicator

    render layout: 'form'
  end

  def create
    indicator = Indicator.create!(indicator_fields)
    log_created(indicator)

    create_references(indicator, references_unsafe_hash)
    add_attachments(indicator, params.dig(:indicator, :attachments))

    redirect_to indicator
  end

  def update
    indicator = Indicator.find(params[:id])
    redirect_to_dashboard && return unless indicator

    indicator.update!(indicator_fields)
    indicator.log_edited(indicator)

    create_references(indicator, references_unsafe_hash)

    redirect_to indicator
  end

  def edit_attachments
    indicator = Indicator.find(params.dig(:attachments, :element_id))
    return unless indicator

    additions = params.dig(:attachments, :additions)
    removal_ids = params.dig(:attachments, :removal_ids)

    add_attachments(indicator, additions) if additions
    remove_attachments(indicator.class.name, indicator, removal_ids) if
        removal_ids

    redirect_to indicator
  end

  private

  def indicator_fields
    fields = params.require(:indicator)

    fields[:margin] = parse_percentage(
      fields, :margin, params.dig(:raw, :margin)
    )

    fields.permit(
      :objective_id, :name, :description, :method,
      :threshold, :criterion, :margin,
      :unit, :responsible_id, :measurement_frequency,
      :comments
    )
  end
end
