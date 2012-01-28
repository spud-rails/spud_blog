// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

Spud = (typeof(Spud) == 'undefined') ? {} : Spud;
Spud.Admin = (typeof(Spud.Admin) == 'undefined') ? {} : Spud.Admin;

Spud.Admin.Posts = new function(){
	
	var self = this;

	this.edit = function(){
		$('input[type=submit],.close_dialog').button();
		initDatePicker();
		initWysiwym();
		$('#spud_post_new_category_form button').live('click', self.didSubmitCategory);
	};

	this.didSubmitCategory = function(event){
		$.ajax({
			url: $('#spud_post_new_category_path').val(),
			type: 'post',
			dataType: 'json',
			data: {
				'spud_post_category[name]': $('#spud_post_new_category_name').val(),
				'spud_post_category[parent_id]': $('#spud_post_new_category_parent_id').val()
			}
		});
	};
};