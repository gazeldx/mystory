module NotesHelper
  def update_info(note)
    info = ""
    if note.created_at.strftime(t('date_format')) != note.updated_at.strftime(t('date_format'))
      info += note.updated_at.strftime(t('time_format')) + t('update')
    end
    info
  end
end