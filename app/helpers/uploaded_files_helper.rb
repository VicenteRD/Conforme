module UploadedFilesHelper
  def icon_for(file_type)
    case file_type
    when 'application/pdf'
      icon_path = 'filetypes/pdf.png'
      icon_alt = 'PDF'
    when 'application/msword',
         'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
         'application/vnd.oasis.opendocument.text'
      icon_path = 'filetypes/word.png'
      icon_alt = 'WORD'
    when 'application/vnd.ms-excel',
         'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
         'application/vnd.oasis.opendocument.spreadsheet'
      icon_path = 'filetypes/xls.png'
      icon_alt = 'XLS'
    when 'text/plain'
      icon_path = 'filetypes/txt.png'
      icon_alt = 'TXT'
    else
      return
    end

    image_tag image_url(icon_path), alt: icon_alt, style: 'height: 1.5em'
  end
end