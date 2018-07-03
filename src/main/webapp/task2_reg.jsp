<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Создание пользователя</title>
</head>
<body>

<style type="text/css">
	.hidden { display:none; }
</style>

<script type="text/javascript" src="jquery-1.12.4.min.js"></script>

<script>
$.urlParam = function(name){
    var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
    if (results==null){
       return null;
    }
    else{
       return decodeURI(results[1]) || 0;
    }
}

function save() {
	var login = $("#login").val(),
		password = $("#password").val(),
		password2 = $("#password_confirm").val(),
		isOperator = '0',
		target = $.urlParam('target');
	
	if($("#oper").is(":checked"))
		isOperator = '1';
	
	if (!password || !login)
		alert('Введите логин и пароль.');
	else
		if (password != password2)
			alert('Пароли не совпадают.');
		else {
			$.ajax({
				url: 'reg_task2',
				type: 'POST',
				dataType: 'xml',
				timeout: 10 * 1000,
				data: 'login=' + login + '&password=' + password + '&isoperator=' + isOperator
			}).then(function (xml) {
				var errCode = jQuery(xml).find('errCode').text(),
					errText = jQuery(xml).find('errText').text();
					
				if (errCode != '0') {
					alert ('Сервер вернул ошибку code ' +  errCode + ': ' + errText);
				} else {
					if (target)
						$(location).attr('href',target);
				}
			}).fail(function () {
					alert('Ошибка отправки запроса');
			});
		}
}
</script>
    <h1>Создание пользователя</h1>

    <form id="request_form">
		<label for="login">Логин:</label>
        <input type="text" name="login" id="login" value="">
		<br>
        <label for="password">Пароль: </label>
        <input type="password" name="password" id="password" value="">
		<br>
		<label for="password_confirm">Пароль(еще раз): </label>
		<input type="password" name="password_confirm" id="password_confirm" value="">
        <br>
		<label for="oper">Роль оператора:</label>
        <input type="checkbox" name="oper" value="1" id="oper">
		<br>
    </form>
	<button onclick="save()">Добавить пользователя</button>
</body>
</html>