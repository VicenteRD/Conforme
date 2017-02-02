module RisksHelper
  def significant_bgcolor(sig)
    tag = 'background-color: '
    case sig
      when 0
        tag + '#ffffff'
      when 1
        tag + '#a9a900'
      when 2
        tag + '#8b0000'
      else
        ''
    end
  end

  def significant_txtcolor(sig)
    tag = 'color: '
    case sig
      when 0
        tag + '#514d64'
      when 1
        tag + '#ffffff'
      when 2
        tag + '#ffffff'
      else
        ''
    end
  end

  def significant_style(sig)
    significant_bgcolor(sig) + '; ' + significant_txtcolor(sig)
  end
end
