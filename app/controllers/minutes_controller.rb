class MinutesController < ApplicationController

  def new
    @folder = MinutesFolder.find(params[:folder_id])
    redirect_to_dashboard && return unless @folder

    render 'minutes_folders/minutes/new', layout: 'form'
  end

  def edit
    @folder = MinutesFolder.find(params[:folder_id])
    redirect_to_dashboard && return unless @folder
    @minute = @folder.find_minute(params[:id])
    redirect_to_dashboard && return unless @minute

    render 'minutes_folders/minutes/edit', layout: 'form'
  end

  def create
    folder = MinutesFolder.find(params[:folder_id])
    redirect_to_dashboard && return unless folder

    minute = folder.new_minute(minute_fields, treated_topics, untreated_topics)
    log_created(minute)

    folder_id = folder.id
    create_references(minute, references_unsafe_hash, folder_id)
    process_attachments(minute, folder_id)

    redirect_to folder
  end

  def update
    folder = MinutesFolder.find(params[:folder_id])
    minute = edit_minute(folder, params[:id])
    redirect_to_dashboard && return unless minute

    log_edited(minute)

    folder_id = folder.id
    create_references(minute, references_unsafe_hash, folder_id)
    process_attachments(minute, folder_id)

    redirect_to folder
  end

  private

  def edit_minute(folder, id)
    return unless folder

    folder.edit_minute(id, minute_fields, treated_topics, untreated_topics)
  end

  def minute_fields
    fields = params.require(:minute)

    parse_datetimes(fields)

    # generate tasks

    fields.permit(
      :name, :editor_id, :comments,
      :start_at, :nxt_start_at, :finish_at, :nxt_finish_at,
      employee_participant_ids: [],
      client_participant_ids: [], provider_participant_ids: [],
      other_participant_ids: []
    )
  end

  def parse_datetimes(fields)
    fields[:start_at] = parse_date(params.dig(:raw, :start_at))
    fields[:finish_at] = parse_date(params.dig(:raw, :finish_at))
    fields[:nxt_start_at] = parse_date(params.dig(:raw, :nxt_start_at))
    fields[:nxt_finish_at] = parse_date(params.dig(:raw, :nxt_finish_at))
  end

  def treated_topics
    topics = {}
    0.step do |idx|
      topic = params.dig(:raw, "treated_topic_#{idx}".to_sym)
      treated = params.dig(:raw, "treated_topic_#{idx}_bool".to_sym) || 'false'

      break unless topic && treated

      topics[topic] = treated == 'on'
    end

    topics
  end

  def untreated_topics
    topics = []
    0.step do |idx|
      topic = params.dig(:raw, "untreated_topic_#{idx}".to_sym)
      break unless topic

      topics.push(topic)
    end

    topics
  end

  def process_attachments(minute, folder_id)
    additions = params.dig(:minute, :new_attachments)
    removals = params.dig(:attachments, :removal_ids)

    add_attachments(minute, additions) if additions
    remove_attachments('Minute', minute, removals, folder_id) if removals
  end
end
