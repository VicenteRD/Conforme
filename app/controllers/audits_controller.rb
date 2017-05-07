class AuditsController < ApplicationController
  def index
    @program = AuditProgram.find(params[:program_id])
    redirect_to_dashboard && return unless @program

    render layout: 'table'
  end

  def show

  end

  def new
    @program = AuditProgram.find(params[:program_id])
    redirect_to_dashboard && return unless @program

    render layout: 'form'
  end

  def create
    program = AuditProgram.create!(program_fields)
    log_created(program)

    create_references(program, references_unsafe_hash)
    process_attachments(program)

    redirect_to audits_path(program)
  end

  private

  def audit_fields
    fields = params.require(:audit)

    fields[:audited_at] = parse_date(params.dig(:raw, :audited_at))

    fields.permit(:name, :audited_at)
  end

  def process_attachments(audit)
    additions = params.dig(:audit, :new_attachments)
    removals = params.dig(:attachments, :removal_ids)

    add_attachments(audit, additions) if additions
    remove_attachments('AuditProgram', audit, removals) if removals
  end
end
