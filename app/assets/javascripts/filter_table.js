(function( $ ) {
  $.fn.filterable = function(options) {
    var defaults = {
      inputSelector: '.filterer',
      hasHeaderRow: true
    };
    var settings = $.extend( {}, defaults, options );
    var $input = $(settings.inputSelector);
    var $rows = this.find('tr');

    if (settings.hasHeaderRow) {
      $rows = $rows.not(':first');
    }

    _bindFilterEvent($input, $rows);

    return this;
  };

  function _bindFilterEvent($input, $rows) {
    $input.on('keyup', function() {
      var val = $.trim($(this).val()).replace(/ +/g, ' ').toLowerCase();

      $rows.show().filter(function() {
          var text = $(this).text().replace(/\s+/g, ' ').toLowerCase();
          return !~text.indexOf(val);
      }).hide();
    });
  };
})( jQuery );
