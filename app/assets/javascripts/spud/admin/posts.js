//= require spud/admin/post_categories

spud = (typeof(spud) == 'undefined') ? {} : spud;
spud.admin = (typeof(spud.admin) == 'undefined') ? {} : spud.admin;

spud.admin.posts = new function(){

	var self = this;

	this.edit = function(){
		spud.admin.date_picker.init()

		$('body').on('click', '.spud_post_add_category', self.clickedPostAddCategory);
		$('body').on('click', '.save_post_category_button', self.submittedPostCategoryForm);
		$('body').on('submit', '.spud_post_category_form', self.submittedPostCategoryForm);
	};

	this.clickedPostAddCategory = function(e){
		e.preventDefault();
		$.ajax({
			url: $(this).attr('href'),
			dataType: 'html',
			success: function(html, textStatus, jqXHR){
				displayModalDialogWithOptions({
					title: 'Add Category',
					html: html
				});
			}
		});
	};

	this.submittedPostCategoryForm = function(e){
		e.preventDefault();
		var form = $('.spud_post_category_form');
		$.ajax({
			url: form.attr('action'),
			data: form.serialize(),
			type: 'post',
			dataType: 'json',
			success: self.savedPostCategorySuccess,
			error: self.savePostCategoryError
		});
	};

	this.savedPostCategorySuccess = function(data, textStatus, jqXHR){
		var checkbox = '';
		checkbox += '<li class="spud_post_form_category" data-id="'+data.id+'">';
		checkbox += '<input id="spud_post_category_'+data.id+'" name="spud_post[category_ids][]" type="checkbox" value="'+data.id+'" checked>' + "\n";
		checkbox += '<label for="spud_post_category_'+data.id+'">'+data.name+'</label>';
		checkbox += '<ul></ul></li>';
		if(data.parent_id > 0){
			$('.spud_post_form_category[data-id="'+data.parent_id+'"]>ul').append(checkbox);
		}
		else{
			$('.spud_post_categories_form').append(checkbox);
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
