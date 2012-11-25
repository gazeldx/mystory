module NotesHelper 

  def link_to_note(note)
    if note.title.to_s==''
      link_to t('s_note', :w => note.created_at.strftime(t'date_format')), note
    else
      link_to raw(note.title)[0..30], note
    end
  end

  def link_to_user_note(note)
    if note.title.to_s==''
      link_to t('s_note', :w => note.created_at.strftime(t'date_format')), site(note.user) + note_path(note)
    else
      link_to raw(note.title), site(note.user) + note_path(note)
    end
  end

  def link_to_note_blank(note)
    if note.title.to_s==''
      link_to t('s_note', :w => note.created_at.strftime(t'date_format')), note, target: '_blank'
    else
      link_to raw(note.title)[0..30], note, target: '_blank'
    end
  end

  def link_to_user_note_blank(note)
    if note.title.to_s==''
      link_to t('s_note', :w => note.created_at.strftime(t'date_format')), site(note.user) + note_path(note), target: '_blank'
    else
      link_to raw(note.title), site(note.user) + note_path(note), target: '_blank'
    end
  end

  def m_link_to_user_note(note)
    if note.title.to_s==''
      link_to t('s_note', :w => note.created_at.strftime(t'date_format')), m(site(note.user) + note_path(note))
    else
      link_to raw(note.title), m(site(note.user) + note_path(note))
    end
  end

  def m_link_to_user_note_slim(note)
    if note.title.to_s==''
      link_to note.created_at.strftime(t'date_without_year'), m(site(note.user) + note_path(note))
    else
      link_to raw(note.title), m(site(note.user) + note_path(note))
    end
  end

  def edit_delete_note
    if @note.user_id == session[:id]
      raw "&nbsp;#{link_to t('edit'), edit_note_path(@note)}&nbsp;#{link_to t('delete'), @note, confirm: t('confirm.delete'), method: :delete}"
    end
  end
end