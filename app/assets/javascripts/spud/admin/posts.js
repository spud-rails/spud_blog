// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

Spud = (typeof(Spud) == 'undefined') ? {} : Spud;
Spud.Admin = (typeof(Spud.Admin) == 'undefined') ? {} : Spud.Admin;

Spud.Admin.Posts = new function(){
	
	var self = this;

	this.edit = function(){
		$('input[type=submit],.close_dialog').button();
		initDatePicker();
		initTinyMCE();
		$('#spud_post_new_category_form button').live('click', self.didSubmitCategory);
		$('.spud_post_add_category').live('click', self.clickedPostAddCategory);
		$('.save_post_category_button').live('click', self.clickedSavePostCategory);
		$('.spud_post_category_form').live('submit', self.submittedPostCategoryForm);
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

	this.clickedPostAddCategory = function(e){
		e.preventDefault();
		$.ajax({
			url: $(this).attr('href'),
			dataType: 'html',
			success: function(html, textStatus, jqXHR){
				displayModalDialogWithOptions({
					title: 'Add Category',
					html: html,
					buttons: {
						save_post_category_button: 'Save'
					}
				});
			}
		});
	};

	this.clickedSavePostCategory = function(e){
		e.preventDefault();
		self.submittedPostCategoryForm();
	};

	this.submittedPostCategoryForm = function(e){
		var form = $('.spud_post_category_form');
		$.ajax({
			url: form.attr('action'),
			data: form.serialize(),
			type: 'post',
			dataType: 'json',
			success: self.savedPostCategorySuccess,
			error: self.savePostCategoryError
		});
		return false;
	};

	this.savedPostCategorySuccess = function(data, textStatus, jqXHR){
		var checkbox = '';
		checkbox += '<li class="spud_post_form_category">';
		checkbox += '<input id="spud_post_category_'+data.id+'" name="spud_post[category_ids][]" type="checkbox" value="'+data.id+'">';
		checkbox += '<label for="spud_post_category_'+data.id+'">'+data.name+'</label>';
		checkbox += '</li>';
		if(data.parent_id > 0){
			$('.spud_post_form_category[data-id="'+data.parent_id+'"] ul').prepend(checkbox);
		}
		else{
			$('.spud_post_categories_form').prepend(checkbox);
		}
		hideModalDialog();
	};

	this.savePostCategoryError = function(jqXHR, textStatus, errorThrown){
		if(jqXHR.status == 422){
			var html = jqXHR.responseText;
			$('.spud_post_category_form').replaceWith(html);
		}
		else{
			if(window.console){
        console.error('Oh Snap:', arguments);
      }
		}
	};
};