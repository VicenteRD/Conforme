module PositionsHelper

  def generate_organization_chart(parent_id = nil)
    if parent_id.nil?
      parent = Position.or({:parent_id => nil}, {:parent_id.exists => false}).first
    else
      parent = Position.find(parent_id)
    end

    return <<-EOS
<li class="#{(parent.area ? 'area-position' : 'position')}">
  <p data-id="#{parent.id}">
    #{parent.name}
  </p>
  <ul>#{generate_branches(parent.children_ids)}</ul>
</li>
              EOS
  end

  def generate_branches(branches_ids)
    if branches_ids.nil? or branches_ids.empty?
      return ''
    end

    puts branches_ids

    branches_text = ''

    branches_ids.each { |branch_id|
      puts branch_id

      child = Position.find(branch_id)

      branches_text += <<-EOS
  <li class="#{(child.area ? 'area-position' : 'position')}">
    <p data-id="#{branch_id}">
      #{child.name}
    </p>
   <ul>#{ generate_branches(child.children_ids) }</ul>
  </li>
                EOS
    }

    branches_text
  end

  def area_selector_style
    return <<-EOS
<style>
  .position {
    color: #827ca1;
  }
  .area-position {
    color: #827ca1;
    cursor: pointer !important;
  }

  .area-position p {
    color: #827ca1;
  }

  .area-position:hover p {
    color: #24222f;
  }
</style>
    EOS
  end

  def position_selector_style
    return <<-EOS
<style>
  .node {
    color: #827ca1;
    cursor: pointer !important;
  }

  .node p {
    color: #827ca1;
  }

  .node:hover p {
    color: #24222f;
  }
</style>
    EOS
  end
end