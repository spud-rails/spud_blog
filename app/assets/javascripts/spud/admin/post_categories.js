spud = (typeof(spud) == 'undefined') ? {} : spud;
spud.admin = (typeof(spud.admin) == 'undefined') ? {} : spud.admin;

spud.admin.post_categories = new function(){

  var self = this;
  var _cachedCategoryIndex;

  this.index = function(){
    $('body').on('click', '.spud_blog_manage_categories', self.clickedManageCategories);
    $('body').on('click', '.spud_blog_category_add_new', self.clickedAddNewCategory);
    $('body').on('click', '.spud_blog_category_edit', self.clickedEditCategory);
    $('body').on('click', '.spud_blog_manage_categories_back', self.clickedBackButton);
    $('body').on('click', '.spud_blog_manage_categories_save', self.submittedPostCategoryForm);
    $('body').on('submit', '.spud_post_category_form', self.submittedPostCategoryForm);
    $('body').on('click', '.spud_blog_category_delete', self.clickedDeleteCategory);
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
        $('.modal-footer button[data-dismiss="modal"]').hide();
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
        $('.modal-footer button[data-dismiss="modal"]').hide();
        $('.spud_blog_manage_categories_save, .spud_blog_manage_categories_back').show();
        $('.spud_blog_category_manager').replaceWith(html);
      }
    });
  };

  this.clickedBackButton = function(e){
    e.preventDefault();
    $('.spud_post_category_form').replaceWith(_cachedCategoryIndex);
    $('.modal-footer button[data-dismiss="modal"]').show();
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