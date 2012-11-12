//= require spud/admin/post_categories

Spud = (typeof(Spud) == 'undefined') ? {} : Spud;
Spud.Admin = (typeof(Spud.Admin) == 'undefined') ? {} : Spud.Admin;

Spud.Admin.Posts = new function(){
	
	var self = this;

	this.index = function(){
		$('.spud_blog_manage_categories').live('click', self.clickedManageCategories);
		$('.spud_blog_category_add_new').live('click', self.clickedAddNewCategory);
		$('.spud_blog_category_edit').live('click', self.clickedEditCategory);
		$('.spud_blog_manage_categories_back').live('click', self.clickedBackButton);
		$('.spud_blog_manage_categories_save').live('click', self.clickedSaveCategory);
		$('.spud_post_category_form').live('submit', self.submittedPostCategoryForm);
		$('.spud_blog_category_delete').live('click', self.clickedDeleteCategory);
	};

	this.edit = function(){
		initDatePicker();
		initTinyMCE();
		$('.spud_post_add_category').live('click', self.clickedPostAddCategory);
		$('.save_post_category_button').live('click', self.submittedPostCategoryForm);
		$('.spud_post_category_form').live('submit', self.submittedPostCategoryForm);
	};

	this.clickedManageCategories = function(e){
		e.preventDefault();
		$.ajax({
			url: $(this).attr('href'),
			success: function(html, textStatus, jqXHR){
				displayModalDialogWithOptions({
					title: 'Manage Categories',
					html: html,
					buttons: {
						'spud_blog_manage_categories_back': 'Back',
						'spud_blog_manage_categories_save btn-primary': 'Save'
					}
				});
			}
		});
	};

	var _cachedCategoryIndex;

	this.clickedAddNewCategory = function(e){
		e.preventDefault();
		$.ajax({
			url: $(this).attr('href'),
			dataType: 'html',
			success: function(html, textStatus, jqXHR){
				_cachedCategoryIndex = $('.spud_blog_category_manager').parent().html();
				$('.spud_blog_manage_categories_save, .spud_blog_manage_categories_back').show();
				$('.spud_blog_category_manager').replaceWith(html);
			}
		});
	};

	this.clickedEditCategory = function(e){
		e.preventDefault();
		$.ajax({
			url: $(this).attr('href'),
			dataType: 'html',
			success: function(html, textStatus, jqXHR){
				_cachedCategoryIndex = $('.spud_blog_category_manager').parent().html();
				$('.spud_blog_manage_categories_save, .spud_blog_manage_categories_back').show();
				$('.spud_blog_category_manager').replaceWith(html);
			}
		});
	};

	this.clickedBackButton = function(e){
		e.preventDefault();
		$('.spud_post_category_form').replaceWith(_cachedCategoryIndex);
		$('.spud_blog_manage_categories_save, .spud_blog_manage_categories_back').hide();
	};

	this.clickedDeleteCategory = function(e){
		e.preventDefault();
		$.ajax({
			url: $(this).attr('href'),
			data: {_method: 'delete'},
			dataType: 'html',
			success: function(html, textStatus, jqXHR){
				$('.spud_blog_category_manager').replaceWith(html);
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