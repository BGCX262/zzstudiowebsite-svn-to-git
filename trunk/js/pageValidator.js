// change by mk2.
//

(function($) {
    $.formValidator = {
	    _sustainType : function(elem, setting) {
	        setting = setting || elem.settings[0];
		    switch(setting.validateType) {
			    case "InitValidator":
				    return true;
			    case "InputValidator":
				    return (elem.tagName == "INPUT" || elem.tagName == "TEXTAREA");
			    case "SelectValidator":
				    return elem.tagName == "SELECT";
			    case "CompareValidator":
				    if (elem.tagName == "INPUT" || elem.tagName == "TEXTAREA") {
					    if (elem.type == "checkbox" || elem.type == "radio") return false;
					    return true;
				    }
				    return false;
			    case "AjaxValidator":
				    return false;
			    case "RegexValidator":
				    if (elem.tagName == "INPUT" || elem.tagName == "TEXTAREA") {
					    if (elem.type == "checkbox" || elem.type == "radio") return false;
					    return true;
				    }
				    return false;
		    }
	    },
        
	    initConfig : function(options) {
            var setting = $.extend({
			        validatorGroup : "1",
			        alertMessage: false, //是否弹出窗口
			        onSuccess: null, //mk2: null
			        onError: null, //mk2: null
			        submitOnce:false //校验通过后，是否灰掉所有的提交按钮
		        }, options);
		    $.formValidator._configs = $.formValidator._configs || []; //若使用dictionary或hash方式比较简单
		    var config = $.formValidator._getInitConfig(setting.validatorGroup);
		    if(config) $.extend(config, setting);
		    else $.formValidator._configs.push(setting);
	    },
    	
	    //如果validator对象对应的element对象的validator属性追加要进行的校验。
	    _appendValid : function(elem, setting) {
		    //如果是各种校验不支持的类型，就不追加到。返回-1表示没有追加成功
		    if(!$.formValidator._sustainType(elem, setting)) return -1;
		    if(setting.validateType == "InitValidator" || !elem.settings) elem.settings = [];   
		    elem.settings.push(setting);
		    return elem.settings.length - 1;
	    },
    	
	    //如果validator对象对应的element对象的validator属性追加要进行的校验。
	    _getInitConfig : function(validatorGroup)
	    {
		    var configs = $.map($.formValidator._configs, function(i) {
		            return i.validatorGroup == validatorGroup ? i : null;
		        });
		     return configs[0];
	    },
    	
	    //触发每个控件上的各种校验
	    _triggerValidate : function(elem, setting)
	    {
	        setting = setting || elem.settings[0];
		    switch(setting.validateType)
		    {
			    case "InputValidator":
				    $.formValidator.InputValid(elem, setting);
				    break;
			    case "SelectValidator":
				    $.formValidator.SelectValid(elem, setting);
				    break;
			    case "CompareValidator":
				    $.formValidator.CompareValid(elem, setting);
				    break;
			    case "AjaxValidator":
				    $.formValidator.InputValid(elem, setting);
				    break;
			    case "RegexValidator":
				    $.formValidator.RegexValid(elem, setting);
				    break;
		    }
	    },
    	
	    //根据单个对象,正确:正确提示,错误:错误提示
	    _showMessage : function(returnObj) {
	        var id = returnObj.id
		    var isValid = returnObj.isValid;
		    var setting = returnObj.setting;//正确:setting[0],错误:对应的setting[i]
		    var tip = $("#"+returnObj.id+"Tip");
		    var elem = $("#"+id).get(0);
		    var jo = $(elem);
		    var setting0 = elem.settings[0];
		    var config = $.formValidator._getInitConfig(setting0.validatorGroup);
		    if (!isValid) { //验证失败,给出提示,并重新设置样式 //获取是否自动修正
			    var auto = setting0.automodify && (jo.attr("type") == "text" || jo.attr("type") == "textarea" || jo.attr("type") == "file")
			    if(config.alertMessage) {
				    alert(setting.onerror);
			    }
			    else {
				    tip.removeClass();
				    if(auto) {
					    tip.html(setting.onshow); 
					    tip.addClass("onShow"); 
					    alert(setting.onerror);
				    }
				    else {
					    tip.html(setting.onerror);
					    tip.addClass("onError"); 
				    }
			    }
			    if(auto) jo.val(elem.validoldvalue);
		    }
		    else { //验证成功
			    //验证成功后,如果没有设置成功提示信息,则给出默认提示,否则给出自定义提示;允许为空,值为空的提示
			    if(!config.alertMessage) {
				    tip.removeClass();
				    tip.addClass("onSuccess");
				    if (setting.empty && jo.val().length == 0) 
					    tip.html(setting.onempty);
				    else
					    tip.html(setting.oncorrect);
			    }
		    }
	    },

	    //验证单个是否验证通过,正确返回settings[0],错误返回对应的settings[i]
	    OneIsValid : function (elem, index) {
		    var returnObj = {id: elem.id, isValid: true, index: 0};
		    var settings = elem.settings;
		    //一个控件理捆绑了多种校验方式，要逐一校验
		    for(var i = index ; i < settings.length ; i ++){   
			    returnObj.index = i;
			    returnObj.setting = settings[i];
			    $.formValidator._triggerValidate(elem, settings[i]);
			    if(!settings[i].isValid) {
				    returnObj.isValid = false;
				    return returnObj;
			    }
		    }
		    if(settings[0].onvalid) settings[0].onvalid(elem, $(elem).val());
		    returnObj.setting = settings[0];
		    return returnObj;
	    },

	    //验证所有需要验证的对象，并返回是否验证成功。这里只对标志进行判断。
	    PageIsValid : function (validatorGroup) {
	        validatorGroup = validatorGroup || "1";
		    var isValid = true;
		    var returnObj = null;
		    var thefirstid = null;
		    var config = $.formValidator._getInitConfig(validatorGroup);
		    $("input, textarea, select").each(function() {
			    if(this.settings) {  
			        if(this.settings[0].validatorGroup == validatorGroup) {
				        if(config.alertMessage) {
					        if(isValid) { //如果是弹出窗口的,发现一个错误就马上停止,并提示
						        returnObj = $.formValidator.OneIsValid(this, 1);	
						        if (!returnObj.isValid) {
							        $.formValidator._showMessage(returnObj);
							        isValid = false;
								    thefirstid = thefirstid || returnObj.id;
						        }
					        }
				        }
				        else {
					        returnObj = $.formValidator.OneIsValid(this, 1);	
					        if (!returnObj.isValid) {
							    isValid = false;
							    thefirstid = thefirstid || returnObj.id;
						    }
					        $.formValidator._showMessage(returnObj);
				        }
				    }
			    }
		    });
		    //成功或失败后，进行回调函数的处理，以及成功后的灰掉提交按钮的功能
		    if(isValid) {
                isValid = config.onSuccess ? config.onSuccess() : true;
			    if(config.submitOnce) {
			        $("input[@type='submit']").attr("disabled", true);
			    }
		    }
		    else {
			    if(config.onError) config.onError();
			    if(thefirstid) $("#"+thefirstid).focus();
		    }
		    return isValid;
	    },

	    //ajax校验
	    AjaxValid : function(elem, setting) {
	        setting = setting || elem.settings[0];
		    $.ajax({ 
		        type: setting.type, 
			    url: setting.url, 
			    data: setting.data, 
			    async:setting.async, 
			    dataType:setting.datatype, 
			    success: setting.success, 
			    complete: setting.complete, 
			    beforeSend:setting.beforesend, 
			    error:setting.error, 
			    processData : setting.processdata 
		    });
	    },

	    //对正则表达式进行校验（目前只针对input和textarea）
	    RegexValid : function(elem, setting) {
	        setting = setting || elem.settings[0];
		    var srcTag = elem.tagName;
		    //如果有输入正则表达式，就进行表达式校验
		    if(elem.settings[0].empty && $(elem).val() == "") {
			    setting.isValid = true;
		    }
		    else if (setting.regexp && typeof setting.regexp == "string" && $.trim(setting.regexp) != "") {
			    var exp = new RegExp(setting.regexp, setting.param);
			    setting.isValid = exp.test($(elem).val());
		    }
	    },
    	
	    //对input类型控件进行校验
	    InputValid : function(elem, setting) {
	        setting = setting || elem.settings[0];
		    var jElem = $(elem);
		    var val = jElem.val();
		    var type = elem.type;
		    var len = 0 ;
		    switch(type)
		    {
			    case "text":
			    case "hidden":
			    case "password":
			    case "textarea":
			    case "file":
				    if (val.length == 0 && elem.settings[0].empty) {
					    setting.isValid = true;
					    return;
				    }
				    if (setting.type == "size") { //获得输入的字符长度，并进行校验
					    for (var i = 0; i < val.length; i++) {
						    if (val.charCodeAt(i) >= 0x4e00 && val.charCodeAt(i) <= 0x9fa5) //两字节编码
							    len += 2;
						    else 
							    len++;
					    }
					    setting.isValid = len >= setting.min && len <= setting.max;
				    }
				    else{
					    var checkType = (typeof setting.min);
					    if(checkType == "number") {
						    if(!isNaN(val)) {
							    var nval = parseFloat(val);
							    setting.isValid = nval >= setting.min && nval <= setting.max;
							    if(setting.isValid && setting.valueType == "int") { //如果验证值是整型数, 会自动去掉小数部分
							        jElem.val(parseInt(nval));
							    }
						    }
						    else
							    setting.isValid = false;
					    }
					    else if(checkType == "string") {
						    setting.isValid = val >= setting.min && val <= setting.max;
					    }
				    }
				    break;
			    case "checkbox":
			    case "radio": 
				    var sValue = "";
				    var objs = $("input[@type='" + type + "'][@name='" + jElem.attr("name") + "'][@checked]");
				    len = objs.length;
				    if (len == 0 && elem.settings[0].empty) {
					    setting.isValid = true;
				    } 
				    else if(len < setting.min || len > setting.max)
					    setting.isValid =false; 
				    else
					    setting.isValid = true;
				    break;
		    }
	    },
    	
	    SelectValid : function(elem, setting) {
	        setting = setting || elem.settings[0];
		    var isValid = true;
		    var jo;
		    var groupname = $(elem).attr("groupname");
		    if (groupname)
			    jo = $("select[@groupname='" + groupname + "']");
		    else
			    jo = $(elem);
		    //如果存在有关联的一组下拉框，即我选了，其他的也得选
		    jo.each(function() {
			    if(this.options.length > 0 ) {
				    if ($(this).val() == "" || $(this).val() == "-1") 
					    isValid = false;
				    else {
					    isValid = isValid && true;
				    }
			    }
			    else {
				    isValid = isValid && true;
			    }
		    });
		    //都没有选中，并且可以为空
		    if (elem.settings[0].empty && !isValid) isValid = true;
		    setting.isValid = isValid;
	    },
    	
	    CompareValid : function(elem, setting) {
	        setting = setting || elem.settings[0];
		    var srcjo = $(elem);
	        var desjo = $("#" + setting.desID);
	        setting.isValid = false;
		    curvalue = srcjo.val();
		    ls_data = desjo.val();
            //对数值型的，进行转换
		    if(setting.datatype == "number") {
                if(!isNaN(curvalue) && !isNaN(ls_data)) {
				    curvalue = parseFloat(curvalue);
                    ls_data = parseFloat(ls_data);
			    }
			    else 
			        return;
            }
	        switch($.trim(setting.operateor)) {
	            case "==":
	            case "=":
	                setting.isValid = curvalue == ls_data;
	                break;
	            case "!=":
	                setting.isValid = curvalue != ls_data;
	                break;
	            case ">":
	                setting.isValid = curvalue > ls_data;
	                break;
	            case ">=":
	                setting.isValid = curvalue >= ls_data;
	                break;
	            case "<": 
	                setting.isValid = curvalue < ls_data;
	                break;
	            case "<=":
	                setting.isValid = curvalue <= ls_data;
	                break;
	        }
	    }
    }

    //每个校验控件必须初始化的
    $.fn.formValidator = function(options) 
    {
        var jo = this;
        var setting = $.extend({
                validatorGroup : "1",
		        empty :false,
		        submitonce : false,
		        automodify : false,
		        onshow :"请输入内容",
		        onfocus: "请输入内容",
		        oncorrect: "输入正确",
		        onempty: "输入内容为空",
		        onvalid : null,
		        onfocusevent : null,
		        onblurevent : null,
		        validateType : "InitValidator"
            }, options);
	    return jo.each(function() {
		    var trigger = this;
		    $.formValidator._appendValid(this, setting);
		    var config = $.formValidator._getInitConfig(setting.validatorGroup);
		    if(!config.alertMessage)
		    {
			    //初始化提示对象的样式和文字
			    var tip = $( "#"+ trigger.id +"Tip" );
			    tip.html(setting.onshow);
			    tip.removeClass();
			    tip.addClass( "onShow" ); 
		    }
		    //获得element对象
		    var srcTag = trigger.tagName;
    		
		    if (srcTag == "INPUT" || srcTag=="TEXTAREA")
		    {
		        var joeach = $(trigger);
			    var stype = joeach.attr("type");
			    var defaultVal = joeach.val();
			    //只要有值,就默认算合法
			    if (!defaultVal && defaultVal != '') setting.isValid = true;
			    //设置默认选中的值
			    if (stype == "checkbox" || stype == "radio") {
				    joeach = $("input[@name=" + joeach.attr("name") + "]");
				    //设置默认选中的值
				    var checkedValue = joeach.attr("checkedValue");
				    if (checkedValue) {
					    joeach.each(function() {
						    if (this.value == checkedValue) {
							    this.checked = "checked";
						    }
					    });
				    }
			    }
			    //注册获得焦点的事件。改变提示对象的文字和样式，保存原值
			    joeach.focus(function() {	
				    if(!config.alertMessage) {
					    var tip = $("#" + trigger.id + "Tip");
					    tip.html(setting.onfocus);			 
					    tip.removeClass();
					    tip.addClass("onFocus");
				    }
				    if (stype == "text" || stype == "textarea" || stype == "file") {
					    this.validoldvalue = $(this).val();
				    }
				    if(setting.onfocusevent) setting.onfocusevent(trigger);
			    });
			    //注册失去焦点的事件。进行校验，改变提示对象的文字和样式；出错就提示处理
			    joeach.blur(function() {   
				    var thefirstsettings = trigger.settings;
				    var settingslen = thefirstsettings.length;
				    var returnObj = $.formValidator.OneIsValid(trigger, 1);
				    //出错或成功的setting如果是ajax校验,就等待异步返回结果再_showMessage
				    if (thefirstsettings[returnObj.index].validateType != "AjaxValidator") {
					    $.formValidator._showMessage(returnObj);
				    }
				    if(setting.onblurevent) setting.onblurevent(trigger);
			    });
		    } 
		    else if (srcTag == "SELECT") { //如果存在一组的select，则只需注册改组的第一个；
			    //设置默认选中的值，存在就算默认校验通过
			    var groupname = $(trigger).attr("groupname");
			    var joeach = groupname ? $("select[@groupname='" + groupname + "']") : $(trigger);
			    joeach.each(function() {							
				    var selectedValue = $(this).attr('selectedValue');	
				    if (selectedValue) {			 
					    $.each(this.options, function() {		
						    if ($.trim(this.value) == $.trim(selectedValue) || this.text == selectedValue) {    
							    this.selected = true;
							    setting.isValid = true;				  
						    }
					    });				  
				    }
			    });
			    //注册获得焦点的事件。改变提示对象的文字和样式
			    joeach.focus(function() {	
				    if(!config.alertMessage) {
					    var tip = $( "#" + trigger.id + "Tip" );
					    tip.html(setting.onfocus);			 
					    tip.removeClass();
					    tip.addClass("onFocus");
				    }
			    });
			    //只有进行初始化的select对象触发change事件后才进行ajax校验
			    joeach.bind("change", function() {
				    var settings = trigger.settings;	//只取第一个select
				    var returnObj = $.formValidator.OneIsValid(trigger, 1);	 
				    if (settings[returnObj.index].validateType != "AjaxValidator") {
					    $.formValidator._showMessage(returnObj);
				    }            
			    });
		    }
	    });
    }; 

    $.fn.InputValidator = function(options) {
        var jo = this;  //the jquery object contains the validator elements
	    var setting = $.extend({
		    isValid : false,
		    min : 0,
		    max : 99999999999999,
		    forceValid : false,         //出错时，是否一定要输入正确为止
		    type : "size",
		    valueType: "int",
		    defaultValue: null,
		    onerror: "输入错误",
		    validateType: "InputValidator"
	    }, options);
	    return jo.each(function() {
		    $.formValidator._appendValid(this, setting);
	    });
    }

    //注意一点：对下拉框进行验证，不选中的时候，你设置的值必须为""或者"-1"
    //如果有依赖的下拉框组的话，必须设置groupname为一样
    $.fn.SelectValidator = function(options) {
        var jo = this;
	    var setting = $.extend({
		    isValid : false,
		    onerror:"必须选择",
		    defaultValue:null,
		    validateType:"SelectValidator"
	    }, options);
	    return jo.each(function() {
		    $.formValidator._appendValid(this, setting);
	    });
    }
    //提供比较。扩展（比较大小）
    $.fn.CompareValidator = function(options) {
        var jo = this;
	    var setting = $.extend({
		    isValid : false,
		    desID : "",
		    operateor :"=",
		    onerror:"输入错误",
		    validateType:"CompareValidator"
	    }, options);
	    return jo.each(function(){
		    var li_index = $.formValidator._appendValid(this, setting);
		    if(li_index == -1) return;
		    var elem = this;
		    //当要比较的对象失去焦点的时候，要改变Tip现实的内容
		    $("#"+setting.desID).blur(function() {
			    var returnObj = $.formValidator.OneIsValid(elem, 1);
			    if(!returnObj.isValid && returnObj.index == li_index) {		//如果是比较这里出错，就从比较这里依次触发校验
				    var returnObj = $.formValidator.OneIsValid(elem, li_index);
			    }
			    if(elem.settings[returnObj.index].validateType != "AjaxValidator") {
				    $.formValidator._showMessage(returnObj);
			    }
		    });
	    });
    }

    $.fn.RegexValidator = function(options) {
        var jo = this;
	    var setting = $.extend({
		    isValid : false,
		    regexp : "",
		    param : "i",
		    onerror:"输入的格式不正确",
		    validateType:"RegexValidator"
	    }, options);
	    return jo.each(function() {
		    $.formValidator._appendValid(this, setting);
	    });
    }

    $.fn.AjaxValidator = function(options) {
        var jo = this;
	    var setting = $.extend({
		    isValid : false,
		    url : "",
		    dataType : "resposeText",
		    data : "html",
		    async : true,
		    beforesend : null,
		    success : null,
		    complete : null,
		    processdata : true,
		    onerror:"输入的格式不正确",
		    validateType:"RegexValidator"
	    }, options);
	    return jo.each(function() {
		    $.formValidator._appendValid(this, setting);
	    });
    }
})(jQuery);