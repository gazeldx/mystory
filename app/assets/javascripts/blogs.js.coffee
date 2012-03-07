this.showArticle = (id) ->
  src = $('#'+id+' img').attr('src')
  if src.indexOf('arrow2') > 0
    $('#'+id+' img').attr('src', '/images/arrow3.gif')
    $('#'+id).attr('title', '收起文章')
    $('#note_'+id+'_short').css 'display', 'none'
    $('#note_'+id+'_full').css 'display', ''
  else
    $('#'+id+' img').attr('src', '/images/arrow2.gif')
    $('#'+id).attr('title', '展开文章')
    $('#note_'+id+'_short').css 'display', ''
    $('#note_'+id+'_full').css 'display', 'none'