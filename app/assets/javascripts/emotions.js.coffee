this.showOrHiddenEmotions = ->
  em = $('#emotions')
  if em.css('display') == 'none'
    em.css 'display', ''
  else
    em.css 'display', 'none'

this.emotionClicked = (emotion) ->
  showOrHiddenEmotions()
  $('#note_text').insertAtCaret "/#{emotion}"

this.initEmotions = ->
  emotions = [[2, '坏笑'], [3, '吃饭'], [4, '调皮'], [5, '尴尬'], [6, '汗'], [7, '惊恐'], [8, '囧'], [9, '可爱'], [10, '酷'], [11, '流口水'], [14, '生病'], [15, '叹气'], [16, '淘气'], [17, '舔'], [18, '偷笑'], [20, '吻'], [21, '晕'], [23, '住嘴'], [201, '大笑'], [202, '害羞'], [203, '口罩'], [204, '哭'], [205, '困'], [206, '难过'], [207, '生气'], [208, '书呆子'], [209, '微笑'], [1, '不'], [210, '惊讶'], [211, '挖鼻孔'], [212, '烧香'], [213, '关注'], [214, '给力'], [215, '鸭梨'], [216, 'hold住'], [217, '降温'], [218, '电风扇'], [219, '烈日'], [220, '鲜花'], [221, '伤不起'], [222, '惊叹号'], [223, '膜拜'], [224, '吐槽'], [225, '禅师'], [226, '雪糕'], [227, '下雨'], [229, '强']]
  htmlStr = ""
  htmlStr += "<li title=\"#{emotion[1]}\" onclick=\"emotionClicked('#{emotion[1]}')\"><img src=\"http://mystory.b0.upaiyun.com/images/emotions/#{emotion[0]}.gif\" /></li>" for emotion in emotions
  $('#emoList0').html htmlStr
  showOrHiddenEmotions()
  $('#emotions_link').attr('onclick', 'showOrHiddenEmotions()')