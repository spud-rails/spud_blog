Spud = (typeof(Spud) == 'undefined') ? {} : Spud;

Spud.Blog = new function(){
  
  var self = this;

  this.init = function(){
    $('.spud_blog_filter_form').live('submit', self.didSubmitFilterForm)
  };

  this.didSubmitFilterForm = function(event){
    event.preventDefault();
    var form = $(this);
    var select = form.find('select');
    var base = form.attr('action');
    var section = select.attr('rel');
    var value = select.val();
    window.location = base + '/' + section + '/' + value;
  };
};

$(document).ready(Spud.Blog.init);