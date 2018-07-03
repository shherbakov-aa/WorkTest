<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Форма обратной связи</title>
</head>
<body>

<style type="text/css">
	.hidden { display:none; }
</style>

<script type="text/javascript" src="jquery-1.12.4.min.js"></script>

<script>
$(document).ready(function(){ 
	getClients();
	if ('${userLogin}' != '')
		$('#logout_div').removeClass("hidden");
	else
		$('#login_div').removeClass("hidden");
});

function sendMessage() {
	var message = $("#message").val(),
		client = $("#client").val();
	
	if (!message || client == '0')
		alert('Необходимо выбрать получателя и ввести текст сообщения.');
	else{
 		$.ajax({
			url: 'send_task2',
			type: 'POST',
			dataType: 'xml',
			timeout: 10 * 1000,
			data: $("#request_form").serialize()
		}).then(function (xml) {

			var errCode = jQuery(xml).find('errCode').text(),
				errText = jQuery(xml).find('errText').text();
				
			if (errCode != '0') {
				alert ('Сервер вернул ошибку code ' +  errCode + ': ' + errText);
			} else {
				alert ('Сообщение отправлено успешно');
			}
		}).fail(function () {
				alert('Ошибка отправки запроса');
		});
	}
}

function getClients() {
	$.ajax({
		url: 'get_clients',
		type: 'POST',
		dataType: 'xml',
		timeout: 10 * 1000,
		data: ''
	}).then(function (xml) {

		var errCode = jQuery(xml).find('errCode').text(),
			errText = jQuery(xml).find('errText').text();
				
		if (errCode != '0') {
			alert ('Ошибка загрузки списка клиентов. Сервер вернул ошибку code ' +  errCode + ': ' + errText);
		} else {
			jQuery(xml).find('client').each(
				function() {
					var _id = jQuery(this).find('id').text(),
						_name = jQuery(this).find('name').text();
				
					$('#client').append('<option value="' + _id + '">' + _name + '</option>');
				}
			);
		}
	}).fail(function () {
			alert('Ошибка загрузки списка клиентов');
	});
}

</script>
	
	<div id="logout_div" class="hidden">
		<span style="color: gray">Здраствуйте, ${userLogin}!</span>
		<a href="logout.jsp">Выйти</a> 
	</div>
	<div id="login_div" class="hidden">
		<span style="color: gray">Здраствуйте, Гость!</span>
		<a href="task2_loginform?target=task2_sendform">Войти</a> 
		<a href="task2_regform?target=task2_sendform">Новый пользователь</a>
	</div>
    <h1>Форма обратной связи</h1>

    <form id="request_form">
		<span style="color: gray">Отправитель</span>
		<br>
		<label for="fromlastname">Фамилия:</label>
        <input type="text" name="fromlastname" id="fromlastname" value="">
		<br>
        <label for="fromfirstname">Имя: </label>
        <input type="text" name="fromfirstname" id="fromfirstname" value="">
		<br>
		<label for="frommiddlename">Отчество: </label>
		<input type="text" name="frommiddlename" id="frommiddlename" value="">
        <br><br>
		<span style="color: gray">Получатель</span>
		<br>
		<label for="client">Выберите получателя:</label>
		<select name="client" id="client">
			<option value="0" selected>-не выбрано-</option>
		</select>
		<br><br>
		<span style="color: gray">Сообщение</span>
		<br>
		<label for="subject">Тема:</label>
		<input type="text" name="subject" id="subject" value="">
		<br>
		<label for="message">Текст сообщения:</label>
		<input type="text" name="message" id="message" value="">
		<br>
    </form>
	<button onclick="sendMessage()">Отправить</button>
</body>
</html>