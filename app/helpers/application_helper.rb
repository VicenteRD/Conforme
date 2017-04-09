module ApplicationHelper

  def print_responsible(id)
    if id && (responsible = Person::User.find(id))
      responsible.first_last_name
    else
      'ERR'
    end
  end

  def person_user_path(user)
    user_path(user)
  end

  def person_provider_path(provider)
    provider_path(provider)
  end

  def person_client_path(client)
    client_path(client)
  end
end
