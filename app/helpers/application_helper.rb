module ApplicationHelper

  def print_responsible(id)
    if id && (responsible = Person::User.find(id))
      responsible.first_last_name
    else
      'ERR'
    end
  end
end
