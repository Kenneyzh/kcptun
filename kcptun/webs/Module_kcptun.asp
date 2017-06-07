<title>软件中心 - Kcptun</title>
<content>
<script type="text/javascript">
getAppData();
var Apps;
function getAppData(){
var appsInfo;
	$.ajax({
	  	type: "GET",
	 	url: "/_api/kcptun_",
	  	dataType: "json",
	  	async:false,
	 	success: function(data){
	 	 	Apps = data.result[0];
	  	}
	});
}

//console.log('Apps',Apps);
//数据 -  绘制界面用 - 直接 声明一个 Apps 然后 post 到 sh 然后 由 sh 执行 存到 dbus
function verifyFields(focused, quiet){
	
	return 1;
}
function save(){
	Apps.kcptun_enable = E('_kcptun_enable').checked ? '1':'0';
	Apps.kcptun_lport = E('_kcptun_lport').value;
	Apps.kcptun_serverip = E('_kcptun_serverip').value;
	Apps.kcptun_mtu = E('_kcptun_mtu').value;
	Apps.kcptun_sndwnd = E('_kcptun_sndwnd').value;
	Apps.kcptun_serverport = E('_kcptun_serverport').value;
	Apps.kcptun_key = E('_kcptun_key').value;
	Apps.kcptun_rcvwnd = E('_kcptun_rcvwnd').value;
	Apps.kcptun_mode = E('_kcptun_mode').value;
	Apps.kcptun_nocomp = E('_kcptun_nocomp').value;
	Apps.kcptun_conn = E('_kcptun_conn').value;
	Apps.kcptun_crypt = E('_kcptun_crypt').value;
	if(Apps.kcptun_serverip == "" || Apps.kcptun_serverport == "" || Apps.kcptun_lport == ""){
		alert("信息填写不完整，请检查后再提交！");
		return false;
	}
	//-------------- post Apps to dbus ---------------
	var id = 1 + Math.floor(Math.random() * 6);
	var postData = {"id": id, "method":'kcptun_config.sh', "params":[], "fields": Apps};
	var success = function(data) {
		//
		$('#footer-msg').text(data.result);
		$('#footer-msg').show();
		setTimeout("window.location.reload()", 3000);

		//  do someting here.
		//
	};
	var error = function(data) {
		//
		//  do someting here.
		//
	};
	$('#footer-msg').text('保存中……');
	$('#footer-msg').show();
	$('button').addClass('disabled');
	$('button').prop('disabled', true);
	$.ajax({
	  type: "POST",
	  url: "/_api/",
	  data: JSON.stringify(postData),
	  success: success,
	  error: error,
	  dataType: "json"
	});
	
	//-------------- post Apps to dbus ---------------
}
</script>
<div class="box">
<div class="heading">kcptun <a href="javascript:history.back()" class="btn" style="float:right;border-radius:3px;">返回</a></div>
<br><hr>
<div class="content">
<div id="kcptun-fields"></div>
<script type="text/javascript">
var option_mode = [['fast2', 'fast2'], ['fast', 'fast'], ['fast3', 'fast3'], ['normal', 'normal'], ['default', 'default']];
var nocomp_mode = [['false', '禁用'], ['true', '启用']];
var crypt_mode = [['aes', 'aes'], ['aes-128', 'aes-128'], ['aes-192', 'aes-192'], ['none', 'none'], ['blowfish', 'blowfish'], ['twofish', 'twofish'], ['salsa20', 'salsa20'], ['cast5', 'cast5'], ['3des', '3des'], ['tea', 'tea'], ['xtea', 'xtea'], ['xor', 'xor']];
$('#kcptun-fields').forms([
{ title: '开启kcptun', name: 'kcptun_enable', type: 'checkbox', value: ((Apps.kcptun_enable == '1')? 1:0)},
{ title: '运行状态', name: 'kcptun_last_act', text: Apps.kcptun_last_act ||'--' },
{ title: '本地侦听端口', name: 'kcptun_lport', type: 'text', maxlen: 5, size: 6, value: Apps.kcptun_lport },
{ title: '服务器地址', name: 'kcptun_serverip', type: 'text', maxlen: 34, size: 36, value: Apps.kcptun_serverip },
{ title: '服务器端口', name: 'kcptun_serverport', type: 'text', maxlen: 5, size: 6, value:Apps.kcptun_serverport },
{ title: '密码', name: 'kcptun_key', type: 'text', maxlen: 32, size: 34, value: Apps.kcptun_key },
{ title: '加密方式', name: 'kcptun_crypt', type: 'select', options:crypt_mode, value: Apps.kcptun_crypt || 'aes' },
{ title: '模式', name: 'kcptun_mode', type: 'select', options:option_mode, value: Apps.kcptun_mode || 'fast2' },
{ title: 'nocomp', name: 'kcptun_nocomp', type: 'select', options:nocomp_mode, value: Apps.kcptun_nocomp || 'false' },
{ title: 'MTU', name: 'kcptun_mtu', type: 'text', maxlen: 10, size: 10, value: Apps.kcptun_mtu || '1400' },
{ title: 'Sndwnd', name: 'kcptun_sndwnd', type: 'text', maxlen: 10, size: 10,value:Apps.kcptun_sndwnd || '256'},
{ title: 'Rcvwnd', name: 'kcptun_rcvwnd', type: 'text', maxlen: 10, size: 10, value: Apps.kcptun_rcvwnd || '2048' },
{ title: 'Conn', name: 'kcptun_conn', type: 'text', maxlen: 2, size: 2, value: Apps.kcptun_conn || '1' },
]);
</script>
</div>
</div>
<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
<script type="text/javascript">verifyFields(null, 1);</script>
</content>
