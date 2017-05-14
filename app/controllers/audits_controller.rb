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

  def edit
    @program = AuditProgram.find(params[:program_id])
    redirect_to_dashboard && return unless @program
    @audit = @program.audits.find(params[:id])
    redirect_to_dashboard && return unless @audit

    render layout: 'form'
  end

  def create
    program = AuditProgram.find(params[:program_id])
    redirect_to_dashboard && return unless program

    audit = program.create_audit(audit_fields)

    log_created(audit)

    process_items(audit)

    create_references(audit, references_unsafe_hash)
    process_attachments(audit)

    redirect_to audit_path(program, audit)
  end

  def update
    program = AuditProgram.find(params[:program_id])

    audit = update_audit(program, params[:id])

    redirect_to_dashboard && return unless audit

    log_edited(audit)

    process_items(audit)

    create_references(audit, references_unsafe_hash)
    process_attachments(audit)

    redirect_to audit_path(program, audit)
  end

  private

  def update_audit(program, id)
    return nil unless program
    program.update_audit(id, audit_fields)
  end

  def audit_fields
    fields = params.require(:audit)

    fields[:audited_at] = parse_date(params.dig(:raw, :audited_at))

    fields.permit(:name, :audited_at, :master_auditor_id, :comments)
  end

  def process_attachments(audit)
    additions = params.dig(:audit, :new_attachments)
    removals = params.dig(:attachments, :removal_ids)

    add_attachments(audit, additions) if additions
    remove_attachments('AuditProgram', audit, removals) if removals
  end

  def process_items(audit)
    0.step do |person_idx|
      person_key = "person_#{person_idx}".to_sym

      person = params[person_key]

      break unless person

      create_items_for_person(audit, person)
    end
  end

  def create_items_for_person(audit, person)
    0.step do |item_idx|
      item_key = "item_#{item_idx}".to_sym
      break unless person[item_key]

      create_item(audit, person, item_key)
    end
  end

  def create_item(audit, person, item_key)
    item_fields = item_fields(person, item_key)

    item_id = person.dig(item_key, :id)
    if item_id.nil? || item_id.empty?
      audit.create_item(item_fields)
    else
      audit.update_item(item_id, item_fields)
    end
  end

  def item_fields(person, item_key)
    {
      area_id: person[:area_id],
      location: person[:location],
      auditor_id: person[:auditor_id],
      audited_id: person[:audited_id],
      hour: person[:hour],
      klass: person[item_key][:klass],
      element_id: person[item_key][:element_id],
      requirement: person[item_key][:requirement]
    }
  end
end
