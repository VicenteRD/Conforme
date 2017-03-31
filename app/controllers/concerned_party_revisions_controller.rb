class ConcernedPartyRevisionsController < ApplicationController
  def new
    @concerned_party = ConcernedParty.find(params[:party_id])
    redirect_to_dashboard && return unless @concerned_party

    render 'concerned_parties/revisions/new', layout: 'form'
  end

  def edit
    @concerned_party = ConcernedParty.find(params[:party_id])
    redirect_to_dashboard && return unless @concerned_party
    @revision = @concerned_party.find_revision(params[:id])
    redirect_to_dashboard && return unless @revision

    render 'concerned_parties/revisions/edit', layout: 'form'
  end

  def create
    concerned_party = ConcernedParty.find(params[:party_id])
    redirect_to_dashboard && return unless concerned_party

    revision = concerned_party.new_revision(
      current_user_id,
      revision_fields,
      log_body
    )

    create_references(revision, references_unsafe_hash, concerned_party.id)

    redirect_to concerned_party_path(concerned_party)
  end

  def update
    concerned_party = ConcernedParty.find(params[:party_id])
    redirect_to_dashboard && return unless concerned_party
    revision = concerned_party.find_revision(params[:id])
    redirect_to_dashboard && return unless revision

    revision.update_and_log(
      current_user_id,
      revision_fields,
      log_body
    )

    # create_references(objective, references_unsafe_hash, swot.id)

    redirect_to concerned_party_path(concerned_party)
  end

  private

  def revision_fields
    fields = params.require(:revision)

    fields[:revised_at] = parse_date(params.dig(:raw, :revised_at))

    attachments = fields[:attachments]
    fields[:attachment_ids] = upload_files(attachments) if attachments


    fields.permit(:revised_at, :comments, attachment_ids: [])
  end
end
