KindEditor.ready(function(K) {
  K.create('#kindeditor_id', {
    width: "100%",
    allowFileManager: true,
    uploadJson: '/kindeditor/upload',
    fileManagerJson: '/kindeditor/filemanager',
    items : [
    'fontname', 'fontsize', '|', 'forecolor', 'hilitecolor', 'bold', 'italic', 'underline',
    'removeformat', '|', 'justifyleft', 'justifycenter', 'justifyright', 'insertorderedlist',
    'insertunorderedlist', '|', 'emoticons', 'image', 'link']
  });
});