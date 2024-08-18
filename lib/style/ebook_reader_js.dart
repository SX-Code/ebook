class EbookReaderJsCss {
  static EbookReaderJsCss? _instance;

  EbookReaderJsCss._();

  static EbookReaderJsCss instance() {
    return _instance ?? EbookReaderJsCss._();
  }

  String customStyleCss =
      '#membership-bar-container,.open-in-app,.top-panel-container{display:none}.controls-list svg.light{display:none}.controls-list.mobile .controls-item b::after{background-image:none!important}.controls-ark-salon a label::after{display:none!important}.controls-ark-salon,.controls-list .require-login{display:none!important}.toc .is-current a{color:#3ca9fc!important}.toc .icon-locked{margin-right:20px}#similar-works-root{display:none}';

  /// 主题css，如果添加新主题，请重写生成
  String customThemeCSS =
      'body.theme0,body.theme0 .inner .page{background-color:#ffffff!important;color:#000000}body.theme0 .aside-controls{background-color:#ffffff!important}body.theme0 .toc .text,body.theme0 .toc .title{color:#000000}body.theme0 .toc,body.theme0 .toc .ft{background-color:#ffffff}body.theme0 .toc .is-current{background-color:#ffffff!important;color:#000000}body.theme0 .toc-contents li:hover{background-color:#ffffff!important}body.theme0 .controls-item b,body.theme0 .controls-item label{color:#000000!important} truebody.theme1,body.theme1 .inner .page{background-color:#e0d9c5!important;color:#000000}body.theme1 .aside-controls{background-color:#e0d9c5!important}body.theme1 .toc .text,body.theme1 .toc .title{color:#000000}body.theme1 .toc,body.theme1 .toc .ft{background-color:#e0d9c5}body.theme1 .toc .is-current{background-color:#e0d9c5!important;color:#000000}body.theme1 .toc-contents li:hover{background-color:#e0d9c5!important}body.theme1 .controls-item b,body.theme1 .controls-item label{color:#000000!important} truebody.theme2,body.theme2 .inner .page{background-color:#d7e3cb!important;color:#000000}body.theme2 .aside-controls{background-color:#d7e3cb!important}body.theme2 .toc .text,body.theme2 .toc .title{color:#000000}body.theme2 .toc,body.theme2 .toc .ft{background-color:#d7e3cb}body.theme2 .toc .is-current{background-color:#d7e3cb!important;color:#000000}body.theme2 .toc-contents li:hover{background-color:#d7e3cb!important}body.theme2 .controls-item b,body.theme2 .controls-item label{color:#000000!important} truebody.theme3,body.theme3 .inner .page{background-color:#ced8e4!important;color:#000000}body.theme3 .aside-controls{background-color:#ced8e4!important}body.theme3 .toc .text,body.theme3 .toc .title{color:#000000}body.theme3 .toc,body.theme3 .toc .ft{background-color:#ced8e4}body.theme3 .toc .is-current{background-color:#ced8e4!important;color:#000000}body.theme3 .toc-contents li:hover{background-color:#ced8e4!important}body.theme3 .controls-item b,body.theme3 .controls-item label{color:#000000!important} truebody.theme4,body.theme4 .inner .page{background-color:#121212!important;color:#ffffff}body.theme4 .aside-controls{background-color:#121212!important}body.theme4 .toc .text,body.theme4 .toc .title{color:#ffffff}body.theme4 .toc,body.theme4 .toc .ft{background-color:#121212}body.theme4 .toc .is-current{background-color:#121212!important;color:#ffffff}body.theme4 .toc-contents li:hover{background-color:#121212!important}body.theme4 .controls-item b,body.theme4 .controls-item label{color:#ffffff!important}';

  /// 加入书架页面
  String getEbookDetailCss(bool isDark) {
    if (isDark) {
    return 'footer.toolbar::after{border: none!important;}#page .profile{padding-top:100px}#page,html,body,.profile-main,.toolbar, #viewport, .profile-main h2, .profile-main h4,footer.toolbar .add-to-bookshelf::after{background:#121212!important;color: #ffffff!important;}#page .profile .cover-side{float:none!important;display:flex!important;justify-content:center!important}#page .profile .inner .profile-main{display:block!important;text-align:center!important}#footer,#header-container,#page .profile .book-rating,#page .profile .meta,#page .profile .rating,.profile-main,.toolbar-col:nth-child(2),.toolbar-col:nth-child(3),.toolbar-container .open-in-app, #bottom-ad-wrapper{display:none!important}.toolbar-container{margin-top:20px}.toolbar-col:nth-child(1){width:100%!important}footer.toolbar{position:unset!important}';
    }
    return 'footer.toolbar::after{border: none!important;}#page .profile{padding-top:100px}#page,html,body,.profile-main,.toolbar, #viewport,.profile-main h2, .profile-main h4,footer.toolbar .add-to-bookshelf::after{background:#ffffff!important;color: #000000!important;}#page .profile .cover-side{float:none!important;display:flex!important;justify-content:center!important}#page .profile .inner .profile-main{display:block!important;text-align:center!important}#footer,#header-container,#page .profile .book-rating,#page .profile .meta,#page .profile .rating,.profile-main,.toolbar-col:nth-child(2),.toolbar-col:nth-child(3),.toolbar-container .open-in-app, #bottom-ad-wrapper{display:none!important}.toolbar-container{margin-top:20px}.toolbar-col:nth-child(1){width:100%!important}footer.toolbar{position:unset!important}';
  }

  /// 用于生成主题css样式代码
  String generateThemeCode(String theme, String bgColor, String textColor) {
    return "body.$theme,body.$theme .inner .page{background-color:$bgColor!important;color:$textColor}body.$theme .aside-controls{background-color:$bgColor!important}body.$theme .toc .text,body.$theme .toc .title{color:$textColor}body.$theme .toc,body.$theme .toc .ft{background-color:$bgColor}body.$theme .toc .is-current{background-color:$bgColor!important;color:$textColor}body.$theme .toc-contents li:hover{background-color:$bgColor!important}body.$theme .controls-item b,body.$theme .controls-item label{color:$textColor!important} true";
  }

  String getDefaultDarkCss(
      String textColor, String bgColor, int fontSize, int lineHeight) {
    return '.page{overflow: scroll!important}.content p{font-size:${fontSize}px!important;line-height:${lineHeight}px!important;min-height:${lineHeight}px!important;}body, body .inner .page{transition:background-color .2s ease-in-out,color .2s ease-in-out;background-color:$bgColor!important;color:$textColor}body .aside-controls{transition:background-color .2s ease-in-out,color .2s ease-in-out;background-color:$bgColor!important}body .toc .text,body .toc .title{transition:background-color .2s ease-in-out,color .2s ease-in-out;color:$textColor}body .toc,body .toc .ft{transition:background-color .2s ease-in-out,color .2s ease-in-out;background-color:$bgColor}body .toc .is-current{transition:background-color .2s ease-in-out,color .2s ease-in-out;background-color:$bgColor!important;color:$textColor}body .toc-contents li:hover{transition:background-color .2s ease-in-out,color .2s ease-in-out;background-color:$bgColor!important}body .controls-item b,body .controls-item label{transition:background-color .2s ease-in-out,color .2s ease-in-out;color:$textColor!important}';
  }

  static String switchTheme(String classNames, int themeId) {
    // ignore: prefer_interpolation_to_compose_strings
    return r"$('body').removeClass('" +
        classNames +
        r"'); $('body').addClass('theme" +
        themeId.toString() +
        r"');";
  }

  static const String lightIcon =
      r'$(".controls-list svg.light").hide();$(".controls-list svg.dark").show()';
  static const String darkIcon =
      r'$(".controls-list svg.dark").hide();$(".controls-list svg.light").show()';

  String jsEvent1 = r'''
      document.querySelector('b.arkicon-list').appendChild('<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-journal-text" viewBox="0 0 16 16"><path d="M5 10.5a.5.5 0 0 1 .5-.5h2a.5.5 0 0 1 0 1h-2a.5.5 0 0 1-.5-.5zm0-2a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5zm0-2a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5zm0-2a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5z"/><path d="M3 0h10a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2v-1h1v1a1 1 0 0 0 1 1h10a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H3a1 1 0 0 0-1 1v1H1V2a2 2 0 0 1 2-2z"/><path d="M1 5v-.5a.5.5 0 0 1 1 0V5h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1zm0 3v-.5a.5.5 0 0 1 1 0V8h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1zm0 3v-.5a.5.5 0 0 1 1 0v.5h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1z"/></svg>');
      document.querySelector('.controls-list').appendChild('<li class="controls-item comment"><b id="comment"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-chat-square-dots" viewBox="0 0 16 16"><path d="M14 1a1 1 0 0 1 1 1v8a1 1 0 0 1-1 1h-2.5a2 2 0 0 0-1.6.8L8 14.333 6.1 11.8a2 2 0 0 0-1.6-.8H2a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1h12zM2 0a2 2 0 0 0-2 2v8a2 2 0 0 0 2 2h2.5a1 1 0 0 1 .8.4l1.9 2.533a1 1 0 0 0 1.6 0l1.9-2.533a1 1 0 0 1 .8-.4H14a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2z"/><path d="M5 6a1 1 0 1 1-2 0 1 1 0 0 1 2 0zm4 0a1 1 0 1 1-2 0 1 1 0 0 1 2 0zm4 0a1 1 0 1 1-2 0 1 1 0 0 1 2 0z"/></svg></b><label>评论</label></li>')
      document.querySelector('.controls-list').appendChild('<li class="controls-item theme"><b id="switch-theme"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-brightness-high dark" viewBox="0 0 16 16"><path d="M8 11a3 3 0 1 1 0-6 3 3 0 0 1 0 6zm0 1a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM8 0a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-1 0v-2A.5.5 0 0 1 8 0zm0 13a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-1 0v-2A.5.5 0 0 1 8 13zm8-5a.5.5 0 0 1-.5.5h-2a.5.5 0 0 1 0-1h2a.5.5 0 0 1 .5.5zM3 8a.5.5 0 0 1-.5.5h-2a.5.5 0 0 1 0-1h2A.5.5 0 0 1 3 8zm10.657-5.657a.5.5 0 0 1 0 .707l-1.414 1.415a.5.5 0 1 1-.707-.708l1.414-1.414a.5.5 0 0 1 .707 0zm-9.193 9.193a.5.5 0 0 1 0 .707L3.05 13.657a.5.5 0 0 1-.707-.707l1.414-1.414a.5.5 0 0 1 .707 0zm9.193 2.121a.5.5 0 0 1-.707 0l-1.414-1.414a.5.5 0 0 1 .707-.707l1.414 1.414a.5.5 0 0 1 0 .707zM4.464 4.465a.5.5 0 0 1-.707 0L2.343 3.05a.5.5 0 1 1 .707-.707l1.414 1.414a.5.5 0 0 1 0 .708z"/></svg><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-moon-stars light" viewBox="0 0 16 16"><path d="M6 .278a.768.768 0 0 1 .08.858 7.208 7.208 0 0 0-.878 3.46c0 4.021 3.278 7.277 7.318 7.277.527 0 1.04-.055 1.533-.16a.787.787 0 0 1 .81.316.733.733 0 0 1-.031.893A8.349 8.349 0 0 1 8.344 16C3.734 16 0 12.286 0 7.71 0 4.266 2.114 1.312 5.124.06A.752.752 0 0 1 6 .278zM4.858 1.311A7.269 7.269 0 0 0 1.025 7.71c0 4.02 3.279 7.276 7.319 7.276a7.316 7.316 0 0 0 5.205-2.162c-.337.042-.68.063-1.029.063-4.61 0-8.343-3.714-8.343-8.29 0-1.167.242-2.278.681-3.286z"/><path d="M10.794 3.148a.217.217 0 0 1 .412 0l.387 1.162c.173.518.579.924 1.097 1.097l1.162.387a.217.217 0 0 1 0 .412l-1.162.387a1.734 1.734 0 0 0-1.097 1.097l-.387 1.162a.217.217 0 0 1-.412 0l-.387-1.162A1.734 1.734 0 0 0 9.31 6.593l-1.162-.387a.217.217 0 0 1 0-.412l1.162-.387a1.734 1.734 0 0 0 1.097-1.097l.387-1.162zM13.863.099a.145.145 0 0 1 .274 0l.258.774c.115.346.386.617.732.732l.774.258a.145.145 0 0 1 0 .274l-.774.258a1.156 1.156 0 0 0-.732.732l-.258.774a.145.145 0 0 1-.274 0l-.258-.774a1.156 1.156 0 0 0-.732-.732l-.774-.258a.145.145 0 0 1 0-.274l.774-.258c.346-.115.617-.386.732-.732L13.863.1z"/></svg></b><label>主题</label></li>')
      document.querySelector('.controls-list').appendChild('<li class="controls-item setting"><b id="setting"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-gear" viewBox="0 0 16 16"><path d="M8 4.754a3.246 3.246 0 1 0 0 6.492 3.246 3.246 0 0 0 0-6.492zM5.754 8a2.246 2.246 0 1 1 4.492 0 2.246 2.246 0 0 1-4.492 0z"/><path d="M9.796 1.343c-.527-1.79-3.065-1.79-3.592 0l-.094.319a.873.873 0 0 1-1.255.52l-.292-.16c-1.64-.892-3.433.902-2.54 2.541l.159.292a.873.873 0 0 1-.52 1.255l-.319.094c-1.79.527-1.79 3.065 0 3.592l.319.094a.873.873 0 0 1 .52 1.255l-.16.292c-.892 1.64.901 3.434 2.541 2.54l.292-.159a.873.873 0 0 1 1.255.52l.094.319c.527 1.79 3.065 1.79 3.592 0l.094-.319a.873.873 0 0 1 1.255-.52l.292.16c1.64.893 3.434-.902 2.54-2.541l-.159-.292a.873.873 0 0 1 .52-1.255l.319-.094c1.79-.527 1.79-3.065 0-3.592l-.319-.094a.873.873 0 0 1-.52-1.255l.16-.292c.893-1.64-.902-3.433-2.541-2.54l-.292.159a.873.873 0 0 1-1.255-.52l-.094-.319zm-2.633.283c.246-.835 1.428-.835 1.674 0l.094.319a1.873 1.873 0 0 0 2.693 1.115l.291-.16c.764-.415 1.6.42 1.184 1.185l-.159.292a1.873 1.873 0 0 0 1.116 2.692l.318.094c.835.246.835 1.428 0 1.674l-.319.094a1.873 1.873 0 0 0-1.115 2.693l.16.291c.415.764-.42 1.6-1.185 1.184l-.291-.159a1.873 1.873 0 0 0-2.693 1.116l-.094.318c-.246.835-1.428.835-1.674 0l-.094-.319a1.873 1.873 0 0 0-2.692-1.115l-.292.16c-.764.415-1.6-.42-1.184-1.185l.159-.291A1.873 1.873 0 0 0 1.945 8.93l-.319-.094c-.835-.246-.835-1.428 0-1.674l.319-.094A1.873 1.873 0 0 0 3.06 4.377l-.16-.292c-.415-.764.42-1.6 1.185-1.184l.292.159a1.873 1.873 0 0 0 2.692-1.115l.094-.319z"/></svg></b><label>主题</label></li>')
    ''';

  String jsEvent = r'''
      $('b.arkicon-list').append('<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-journal-text" viewBox="0 0 16 16"><path d="M5 10.5a.5.5 0 0 1 .5-.5h2a.5.5 0 0 1 0 1h-2a.5.5 0 0 1-.5-.5zm0-2a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5zm0-2a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5zm0-2a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5z"/><path d="M3 0h10a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2v-1h1v1a1 1 0 0 0 1 1h10a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H3a1 1 0 0 0-1 1v1H1V2a2 2 0 0 1 2-2z"/><path d="M1 5v-.5a.5.5 0 0 1 1 0V5h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1zm0 3v-.5a.5.5 0 0 1 1 0V8h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1zm0 3v-.5a.5.5 0 0 1 1 0v.5h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1z"/></svg>');
      $('.controls-list').append('<li class="controls-item comment"><b id="comment"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-chat-square-dots" viewBox="0 0 16 16"><path d="M14 1a1 1 0 0 1 1 1v8a1 1 0 0 1-1 1h-2.5a2 2 0 0 0-1.6.8L8 14.333 6.1 11.8a2 2 0 0 0-1.6-.8H2a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1h12zM2 0a2 2 0 0 0-2 2v8a2 2 0 0 0 2 2h2.5a1 1 0 0 1 .8.4l1.9 2.533a1 1 0 0 0 1.6 0l1.9-2.533a1 1 0 0 1 .8-.4H14a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2z"/><path d="M5 6a1 1 0 1 1-2 0 1 1 0 0 1 2 0zm4 0a1 1 0 1 1-2 0 1 1 0 0 1 2 0zm4 0a1 1 0 1 1-2 0 1 1 0 0 1 2 0z"/></svg></b><label>评论</label></li>')
      $('.controls-list').append('<li class="controls-item theme"><b id="switch-theme"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-brightness-high dark" viewBox="0 0 16 16"><path d="M8 11a3 3 0 1 1 0-6 3 3 0 0 1 0 6zm0 1a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM8 0a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-1 0v-2A.5.5 0 0 1 8 0zm0 13a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-1 0v-2A.5.5 0 0 1 8 13zm8-5a.5.5 0 0 1-.5.5h-2a.5.5 0 0 1 0-1h2a.5.5 0 0 1 .5.5zM3 8a.5.5 0 0 1-.5.5h-2a.5.5 0 0 1 0-1h2A.5.5 0 0 1 3 8zm10.657-5.657a.5.5 0 0 1 0 .707l-1.414 1.415a.5.5 0 1 1-.707-.708l1.414-1.414a.5.5 0 0 1 .707 0zm-9.193 9.193a.5.5 0 0 1 0 .707L3.05 13.657a.5.5 0 0 1-.707-.707l1.414-1.414a.5.5 0 0 1 .707 0zm9.193 2.121a.5.5 0 0 1-.707 0l-1.414-1.414a.5.5 0 0 1 .707-.707l1.414 1.414a.5.5 0 0 1 0 .707zM4.464 4.465a.5.5 0 0 1-.707 0L2.343 3.05a.5.5 0 1 1 .707-.707l1.414 1.414a.5.5 0 0 1 0 .708z"/></svg><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-moon-stars light" viewBox="0 0 16 16"><path d="M6 .278a.768.768 0 0 1 .08.858 7.208 7.208 0 0 0-.878 3.46c0 4.021 3.278 7.277 7.318 7.277.527 0 1.04-.055 1.533-.16a.787.787 0 0 1 .81.316.733.733 0 0 1-.031.893A8.349 8.349 0 0 1 8.344 16C3.734 16 0 12.286 0 7.71 0 4.266 2.114 1.312 5.124.06A.752.752 0 0 1 6 .278zM4.858 1.311A7.269 7.269 0 0 0 1.025 7.71c0 4.02 3.279 7.276 7.319 7.276a7.316 7.316 0 0 0 5.205-2.162c-.337.042-.68.063-1.029.063-4.61 0-8.343-3.714-8.343-8.29 0-1.167.242-2.278.681-3.286z"/><path d="M10.794 3.148a.217.217 0 0 1 .412 0l.387 1.162c.173.518.579.924 1.097 1.097l1.162.387a.217.217 0 0 1 0 .412l-1.162.387a1.734 1.734 0 0 0-1.097 1.097l-.387 1.162a.217.217 0 0 1-.412 0l-.387-1.162A1.734 1.734 0 0 0 9.31 6.593l-1.162-.387a.217.217 0 0 1 0-.412l1.162-.387a1.734 1.734 0 0 0 1.097-1.097l.387-1.162zM13.863.099a.145.145 0 0 1 .274 0l.258.774c.115.346.386.617.732.732l.774.258a.145.145 0 0 1 0 .274l-.774.258a1.156 1.156 0 0 0-.732.732l-.258.774a.145.145 0 0 1-.274 0l-.258-.774a1.156 1.156 0 0 0-.732-.732l-.774-.258a.145.145 0 0 1 0-.274l.774-.258c.346-.115.617-.386.732-.732L13.863.1z"/></svg></b><label>主题</label></li>')
      $('.controls-list').append('<li class="controls-item setting"><b id="setting"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-gear" viewBox="0 0 16 16"><path d="M8 4.754a3.246 3.246 0 1 0 0 6.492 3.246 3.246 0 0 0 0-6.492zM5.754 8a2.246 2.246 0 1 1 4.492 0 2.246 2.246 0 0 1-4.492 0z"/><path d="M9.796 1.343c-.527-1.79-3.065-1.79-3.592 0l-.094.319a.873.873 0 0 1-1.255.52l-.292-.16c-1.64-.892-3.433.902-2.54 2.541l.159.292a.873.873 0 0 1-.52 1.255l-.319.094c-1.79.527-1.79 3.065 0 3.592l.319.094a.873.873 0 0 1 .52 1.255l-.16.292c-.892 1.64.901 3.434 2.541 2.54l.292-.159a.873.873 0 0 1 1.255.52l.094.319c.527 1.79 3.065 1.79 3.592 0l.094-.319a.873.873 0 0 1 1.255-.52l.292.16c1.64.893 3.434-.902 2.54-2.541l-.159-.292a.873.873 0 0 1 .52-1.255l.319-.094c1.79-.527 1.79-3.065 0-3.592l-.319-.094a.873.873 0 0 1-.52-1.255l.16-.292c.893-1.64-.902-3.433-2.541-2.54l-.292.159a.873.873 0 0 1-1.255-.52l-.094-.319zm-2.633.283c.246-.835 1.428-.835 1.674 0l.094.319a1.873 1.873 0 0 0 2.693 1.115l.291-.16c.764-.415 1.6.42 1.184 1.185l-.159.292a1.873 1.873 0 0 0 1.116 2.692l.318.094c.835.246.835 1.428 0 1.674l-.319.094a1.873 1.873 0 0 0-1.115 2.693l.16.291c.415.764-.42 1.6-1.185 1.184l-.291-.159a1.873 1.873 0 0 0-2.693 1.116l-.094.318c-.246.835-1.428.835-1.674 0l-.094-.319a1.873 1.873 0 0 0-2.692-1.115l-.292.16c-.764.415-1.6-.42-1.184-1.185l.159-.291A1.873 1.873 0 0 0 1.945 8.93l-.319-.094c-.835-.246-.835-1.428 0-1.674l.319-.094A1.873 1.873 0 0 0 3.06 4.377l-.16-.292c-.415-.764.42-1.6 1.185-1.184l.292.159a1.873 1.873 0 0 0 2.692-1.115l.094-.319z"/></svg></b><label>主题</label></li>')
      
      $('.controls-item.toggle-toc').on('click', () => {
        window.flutter_inappwebview.callHandler('showTocCallback');
      })
      $('.controls-item.comment').on('click', () => {
        window.flutter_inappwebview.callHandler('toggleCommentCallback');
      })
      $('.controls-item.theme').on('click', () => {
        window.flutter_inappwebview.callHandler('toggleThemeCallback');
      })
      $('.controls-item.setting').on('click', () => {
        window.flutter_inappwebview.callHandler('toggleSettingsCallback');
      })

      let move = false;
      $(".inner").on("click touchstart touchmove touchend", (event) => {
        switch (event.type) {
          case "touchstart":
            move = false;
            break;
          case "touchmove":
            move = true;
            break;
          case "touchend":
            if (move) {
               window.flutter_inappwebview.callHandler('innerClickCallback');
            }
            break;
          case "tap":
             window.flutter_inappwebview.callHandler('innerClickCallback');
            break;
          case "click":
             window.flutter_inappwebview.callHandler('innerClickCallback');
            break;
        }
      });

    true
    ''';

  static setFontSizeCode(int fontSize, int lineHeight) {
    StringBuffer buf = StringBuffer();
    buf.write(
        r"$('#fontSize').remove();var style = document.createElement('style');style.type = 'text/css';style.rel = 'stylesheet';style.id = '#fontSize'; var code='.content p{font-size: ");
    buf.write(fontSize.toString());
    buf.write("px !important;line-height: ");
    buf.write(lineHeight.toString());
    buf.write("px !important;min-height: ");
    buf.write(lineHeight.toString());
    // buf.write("px !important;margin-bottom: ");
    // buf.write(lineHeight.toString());
    buf.write("px !important;';");
    buf.write(
        "try {style.appendChild(document.createTextNode(code))} catch (ex) {style.styleSheet.cssText = code}document.getElementsByTagName('head')[0].appendChild(style);");
    buf.write('true');
    return buf.toString();
  }
}

// var lis = document.querySelectorAll('ul.toc-contents li');
//       for(var li in lis) {
//         console.log('你好')
//         li.addEventListener("click", () => {
//           window.flutter_inappwebview.callHandler('hideTocCallback')
//           document.querySelector('ul.toc-contents li').style = "display: none";
//         });
//       }
      // var pages = document.querySelector('.inner');
      // pages.addEventListener("click", () => {
      //   window.flutter_inappwebview.callHandler('webViewTouchCallback')
      // });
      //       $('.inner').on('touchend', () => {
        // window.flutter_inappwebview.callHandler('innerClickCallback');
      // })