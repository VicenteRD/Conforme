class Log::Book
  include Mongoid::Document

  embeds_many :entries, class_name: 'Log::Entry'

  # This works, and is more readable than specifying a random, single class, or all of them
  # To eval: Concern TODO
  embedded_in :many

  def new_entry(author_id, title, body)
    self.entries.create!(author_id: author_id, title: title, body: body)
  end

  def print_all
    return_string = ''

    self.entries.each do |entry|
      return_string += "#{entry.c_at.strftime('%d/%m/%y, %H:%M')} || #{entry.get_author_name}: #{entry.body}\n"
    end

    return_string
  end
end
