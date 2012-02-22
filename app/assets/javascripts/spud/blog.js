Spud = (typeof(Spud) == 'undefined') ? {} : Spud;

Spud.Blog = new function(){
  
  var self = this;

  this.init = function(){
    $('.spud_blog_filter_form').live('submit', self.didSubmitFilterForm)
  };

  this.didSubmitFilterForm = function(event){
    event.preventDefault();
    var form = $(this);
    var base = form.attr('action');
    var url = '';

    // find filter values    
    var category_select = $(this).find('select[rel=category]');
    if(category_select){
      var category = category_select.val();
    }
    var archive_select = $(this).find('select[rel=archive]');
    if(archive_select){
      var archive = archive_select.val();
    }

    // build url and redirect
    if(category && archive){
      url = '/category/' + category + '/' + archive;
    }
    else if(category){
      url = '/category/' + category;
    }
    else if(archive){
      url = '/archive/' + archive;
    }
    window.location = base + url;
  };
};

$(document).ready(Spud.Blog.init);