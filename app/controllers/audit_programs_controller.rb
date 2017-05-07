class AuditProgramsController < ApplicationController
  def index
    render layout: 'table'
  end

  def new
    render layout: 'form'
  end

  def show
    redirect_to audits_path(params[:id])
  end

  def create
    program = AuditProgram.create!(program_fields)
    log_created(program)

    create_references(program, references_unsafe_hash)
    process_attachments(program)

    redirect_to audits_path(program)
  end

  def edit

  end

  private

  def program_fields
    fields = params.require(:program)

    fields[:from] = parse_date(params.dig(:raw, :from))
    fields[:to] = parse_date(params.dig(:raw, :to))

    fields.permit(:name, :from, :to)
  end

  def process_attachments(program)
    additions = params.dig(:program, :new_attachments)
    removals = params.dig(:attachments, :removal_ids)

    add_attachments(program, additions) if additions
    remove_attachments('AuditProgram', program, removals) if removals
  end
end
