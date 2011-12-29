module Admin::AceHelper
  include Admin::NodeHelper
  include Admin::ReferencesHelper

  def content_type_for_page(page_part)
    default_content_type = "text/html"
    if page_part.page.nil?
      return default_content_type
    else
      if page_part.page.layout.respond_to?(:content_type)
        return page_part.page.layout.content_type
      else
        return default_content_type
      end
    end
  end
  
  def init_script(tag_id, text_area_id, content_type, filter)
    @javascripts << ["/ace/src/ace.js", "/ace/src/ace-utils.js", "/ace/src/theme-twilight.js", "/ace/src/theme-textmate.js", "/ace/src/mode-html.js", "/ace/src/mode-css.js", "/ace/src/mode-coffee.js", "/ace/src/mode-javascript.js"]
    @stylesheets << ["/ace/src/ace-resize.css"]
    
    case content_type
      
    when "text/javascript"
      if !defined?(CoffeeScriptFilter).nil?
        if filter.is_a? CoffeeScriptFilter
          mode_path = "ace/mode/coffee"
        else
          mode_path = "ace/mode/javascript"
        end
      else
        mode_path = "ace/mode/javascript"      
      end
    when "text/css"
      mode_path = "ace/mode/css"
    else
      mode_path = "ace/mode/html"
    end
    
    <<-CODE
      <script>
        if ( window.editorObserved == undefined) {
          Event.observe(window, 'load', function(event) {
            var textArea = $('#{text_area_id}');
            var editorPre = $("#{tag_id}"); 
            
            window.pageHeight = $('page').clientHeight;
            editorPre.style.height = (window.pageHeight - 540) + 'px';
            window.editorHeight = editorPre.clientHeight;
            
            init_editor('#{tag_id}', '#{text_area_id}', '#{mode_path}');
            
            Event.observe(window, 'resize', function () {
              var diff =  $('page').clientHeight - window.pageHeight;
              window.editorHeight += diff;
              editorPre.style.height = (window.editorHeight) + 'px';
              
              window.pageHeight = $('page').clientHeight;
            }); 
            
            Event.observe(document, 'keypress', function(e){ 
            	var code;
            	if (!e) var e = window.event;
            	if (e.keyCode) code = e.keyCode;
            	else if (e.which) code = e.which;
            	
            	if (code == 13 && e.ctrlKey)
            	{
                switchFullScreen("#{tag_id}", '#{text_area_id}', "#{mode_path}");
                return e.returnValue = false;
            	} 
            });
          });
          window.editorObserved = true;
        } else {
          Event.observe(window, 'load', function(event) {
            var textArea = $('#{text_area_id}');
            textArea.style.display = '';
            
            var editor = $("#{tag_id}");  
            editor.style.display = 'none';
          });
        }
        
      </script>
    CODE
  end


end