<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Авторизация пользователя</title>
</head>
<body>

<style type="text/css">
	.hidden { display:none; }
</style>

<script type="text/javascript" src="jquery-1.12.4.min.js"></script>

<script>
$(document).ready(function(){ 
	var message = decodeURIComponent($.urlParam('message'));
	if (message != '' && message != 'null')
		$("#message").text(message);
});

$.urlParam = function(name){
    var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
    if (results==null){
       return null;
    }
    else{
       return decodeURI(results[1]) || 0;
    }
}

function submitForm() {
	var login = $("#login").val(),
		password = $("#password").val(),
		target = $.urlParam('target');
	
	if (!password || !login)
		alert('Введите логин и пароль.');
	else
		$.ajax({
			url: 'login_task2',
			type: 'POST',
			dataType: 'xml',
			timeout: 10 * 1000,
			data: $("#request_form").serialize()
		}).then(function (xml) {
			var errCode = jQuery(xml).find('errCode').text(),
				errText = jQuery(xml).find('errText').text();
				
			if (errCode != '0') {
				$("#message").text('Ошибка code ' +  errCode + ': ' + errText);
			} else {
				if (target)
					$(location).attr('href',target);
			}
		}).fail(function () {
				alert('Ошибка отправки запроса');
		});
}
</script>
    <h1>Авторизация пользователя</h1>

    <form id="request_form">
		<label for="login">Логин:</label>
        <input type="text" name="login" id="login" value="">
		<br>
        <label for="password">Пароль: </label>
        <input type="password" name="password" id="password" value="">
		<br>
    </form>
	<button onclick="submitForm()">Войти</button>
	<br><br>
	<span id="message" style="color: red"></span>
</body>
</html>