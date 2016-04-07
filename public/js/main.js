$(function(){
  var site_url = location.protocol + '//' + location.host;
  // var site_url = location.protocol + '//' + location.hostname;

  $('#list-settings label').click(function(){
    var label = $(this).attr('for').split('-');
    var site_name = label[0];

    var set_val = label[1];
    var tbl_row = $(this).parents('tr')
    var site_idx = tbl_row.data('site-idx');
    var setting_list = $('#yp-url').val().split(site_url)[1].split('/');

    switch(set_val){
      case 'x' :
        tbl_row.fadeTo('slow', 0.3);
        $('#yp-url').val(changeURL(site_idx, set_val, site_url, setting_list));
        break;
      case '0' :
      case '1' :
        tbl_row.fadeTo('slow', 1);
        $('#yp-url').val(changeURL(site_idx, set_val, site_url, setting_list));
        break;
      case 'cond' :
        var cond_operator = $('#' + site_name + '-cond-operator').val();
        var cond_num = $('#' + site_name + '-cond-num').val();
        set_val = cond_operator + cond_num;
        tbl_row.fadeTo('slow', 1);
        $('#yp-url').val(changeURL(site_idx, set_val, site_url, setting_list));
        break;
      default:
        break;
    }
  });

  $('.cond-operator, .cond-num').change(function(){
    var id = $(this).attr('id').split('-'); // site_id-cond-operator or site_id-cond-num
    var site_name = id[0];
    var cond_operator = $('#' + site_name + '-cond-operator').val();
    var cond_num = $('#' + site_name + '-cond-num').val();

    var set_val;
    var tbl_row = $(this).parents('tr')
    var site_idx = tbl_row.data('site-idx');
    var setting_list = $('#yp-url').val().split(site_url)[1].split('/');

    if($('#' + site_name + '-cond').prop('checked')){
      set_val = cond_operator + cond_num;
      tbl_row.fadeTo('slow', 1);
      $('#yp-url').val(changeURL(site_idx, set_val, site_url, setting_list));
    }
  });
});

function changeURL(site_idx, set_val, site_url, setting_list){
  if((setting_list.length - 2) >= site_idx){ // '前後の空文字分削除'
    setting_list[site_idx] = set_val;
  }

  for(var i = 1; i < setting_list.length; i++){
    site_url += '/' + setting_list[i];
  }
  return site_url;
}
