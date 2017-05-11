class AuditsController < ApplicationController
  def index
    @program = AuditProgram.find(params[:program_id])
    redirect_to_dashboard && return unless @program

    render layout: 'table'
  end

  def show
    @program = AuditProgram.find(params[:program_id])
    redirect_to_dashboard && return unless @program
    @audit = @program.audits.find(params[:id])
    redirect_to_dashboard && return unless @audit

    render layout: 'show'
  end

  def new
    @program = AuditProgram.find(params[:program_id])
    redirect_to_dashboard && return unless @program

    render layout: 'form'
  end

  def create
    program = AuditProgram.find(params[:program_id])
    redirect_to_dashboard && return unless program

    audit = program.create_audit(audit_fields)

    log_created(audit)

    create_items(audit)

    create_references(audit, references_unsafe_hash)
    process_attachments(audit)

    redirect_to audit_path(program, audit)
  end

  private

  def audit_fields
    fields = params.require(:audit)

    fields[:audited_at] = parse_date(params.dig(:raw, :audited_at))

    fields.permit(:name, :audited_at, :master_auditor_id)
  end

  def process_attachments(audit)
    additions = params.dig(:audit, :new_attachments)
    removals = params.dig(:attachments, :removal_ids)

    add_attachments(audit, additions) if additions
    remove_attachments('AuditProgram', audit, removals) if removals
  end

  def create_items(audit)
    0.step do |idx|
      item_idx = "audit_item_#{idx}".to_sym
      break unless params[item_idx]

      audit.create_item(params.require(item_idx).permit(
        :area_id, :auditor_id, :audited_id,
        :location, :hour,
        :klass, :element_id,
        :requirement
    ))

    end
  end
end
