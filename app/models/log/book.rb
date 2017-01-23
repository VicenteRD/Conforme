class Log::Book
  include Mongoid::Document

  embeds_many :log_entries, class_name: 'Log::Entry'

  def new_entry(author, title, body)
    log_entries.create(auth_id: author.to_key, title: title, body: body)
  end

  def print_all
    return_string = ''

    self.log_entries.all.each do |entry|
      return_string += entry.c_at.strftime('%d/%m/%y, %H:%M') + ' || ' + entry.author.name + ': ' + entry.body + "\n"
    end
  end
end
