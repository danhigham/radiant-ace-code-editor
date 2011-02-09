function init_editor(tag_id, text_area_id, mode_path) {
	var editor = ace.edit(tag_id);
    var textArea = $(text_area_id);
    
    editor.renderer.updateFull();  
    editor.setTheme("ace/theme/twilight"); 

    var EditorMode = require(mode_path).Mode;
    var editorSession = editor.getSession();
    
	editorSession.setMode(new EditorMode());
    editorSession.setValue(textArea.value);
    editorSession.setTabSize(2);
	editorSession.setUseSoftTabs(true);
	
	editorSession.on('change', function() { 
		textArea.value = editorSession.toString();
	});
	
	editor.renderer.showCursor();
}

function switchFullScreen(tag_id, text_area_id, mode_path) {
	
	var editorPre = $(tag_id);
	
	if (window.fullscreen == true) {
		editorPre.setStyle({
			position: 'relative',
			height : (window.pageHeight - 540) + 'px',
			top : 0,
			zIndex : 1,
			opacity : 1
		});
				
		window.fullscreen = false;
	} else {
		editorPre.setStyle({
			position: 'absolute',
			height : (window.pageHeight - 79) + 'px',
			top : '79px',
			zIndex : 100,
			opacity : 0.98
		});

		window.fullscreen = true;
	}
	
	init_editor(tag_id, text_area_id, mode_path);
}
