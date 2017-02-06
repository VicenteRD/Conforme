module PositionsHelper

  def generate_organization_chart
    parent = Position.or({:parent_id => nil}, {:parent_id.exists => false}).first


    return <<-EOS
<li>
  <p class="#{(parent.area ? 'area-position' : 'position')}" id="#{parent.id}">
    #{parent.name}
  </p>
  <a href="/posicion/#{parent.id}/nueva">+</a>
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
  <li>
    <p class="#{(child.area ? 'area-position' : '')}" id="#{branch_id}">
      #{child.name}
    </p>
    <a href="/posicion/#{child.id}/nueva">+</a>
   <ul>#{ generate_branches(child.children_ids) }</ul>
  </li>
                EOS
    }

    branches_text
  end
end