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
    party = ConcernedParty.find(params[:party_id])
    redirect_to_dashboard && return unless party

    revision = party.new_revision(revision_fields)
    log_created(revision)

    party_id = party.id
    create_references(revision, references_unsafe_hash, party_id)
    add_attachments(
      revision, params.dig(:revision, :attachments), party_id
    )

    redirect_to party
  end

  def update
    party = ConcernedParty.find(params[:party_id])
    revision = party ? party.find_revision(params[:id]) : nil

    redirect_to_dashboard && return unless revision

    revision.update!(revision_fields)
    log_edited(revision)

    create_references(revision, references_unsafe_hash, party.id)

    redirect_to party
  end

  private

  def revision_fields
    fields = params.require(:revision)

    fields[:revised_at] = parse_date(params.dig(:raw, :revised_at))

    fields.permit(:revised_at, :comments)
  end
end
