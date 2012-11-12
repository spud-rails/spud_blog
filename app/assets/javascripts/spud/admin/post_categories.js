Spud = (typeof(Spud) == 'undefined') ? {} : Spud;
Spud.Admin = (typeof(Spud.Admin) == 'undefined') ? {} : Spud.Admin;

Spud.Admin.PostCategories = new function(){

  var self = this;
  var _cachedCategoryIndex;

  this.index = function(){
    $('.spud_blog_manage_categories').live('click', self.clickedManageCategories);
    $('.spud_blog_category_add_new').live('click', self.clickedAddNewCategory);
    $('.spud_blog_category_edit').live('click', self.clickedEditCategory);
    $('.spud_blog_manage_categories_back').live('click', self.clickedBackButton);
    $('.spud_blog_manage_categories_save').live('click', self.submittedPostCategoryForm);
    $('.spud_post_category_form').live('submit', self.submittedPostCategoryForm);
    $('.spud_blog_category_delete').live('click', self.clickedDeleteCategory);
  };

  this.clickedManageCategories = function(e){
    e.preventDefault();
    $.ajax({
      url: $(this).attr('href'),
      success: function(html, textStatus, jqXHR){
        _cachedCategoryIndex = html;
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

  this.clickedAddNewCategory = function(e){
    e.preventDefault();
    $.ajax({
      url: $(this).attr('href'),
      dataType: 'html',
      success: function(html, textStatus, jqXHR){
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
    if(window.confirm('Are you sure you want to delete this category?')){
      $.ajax({
        url: $(this).attr('href'),
        data: {_method: 'delete'},
        type: 'delete',
        dataType: 'html',
        success: function(html, textStatus, jqXHR){
          _cachedCategoryIndex = html;
          $('.spud_blog_category_manager').replaceWith(html);
        }
      });
    }
  };

this.submittedPostCategoryForm = function(e){
    e.preventDefault();
    var form = $('.spud_post_category_form');
    $.ajax({
      url: form.attr('action'),
      data: form.serialize(),
      type: 'post',
      dataType: 'html',
      success: self.savedPostCategorySuccess,
      error: self.savePostCategoryError
    });
  };

  this.savedPostCategorySuccess = function(html, textStatus, jqXHR){
    _cachedCategoryIndex = html;
    $('.spud_blog_manage_categories_save, .spud_blog_manage_categories_back').hide();
    $('.spud_post_category_form').replaceWith(html);
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