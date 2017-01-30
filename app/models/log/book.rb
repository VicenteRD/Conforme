class Log::Book
  include Mongoid::Document

  embeds_many :entries, class_name: 'Log::Entry'

  embedded_in :risk

  def new_entry(author_id, title, body)
    self.entries.create!(author_id: author_id, title: title, body: body)
  end

  def print_all
    return_string = ''

    self.entries.all.each do |entry|
      return_string += entry.c_at.strftime('%d/%m/%y, %H:%M') + ' || ' + entry.author.name + ': ' + entry.body + "\n"
    end
  end
end
