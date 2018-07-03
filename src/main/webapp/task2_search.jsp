<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Поиск сообщений</title>
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
		$('#login_div').removeClass("hidden");
});

function search() {
	$('#search_res tr:not(:first)').remove();
  
	$.ajax({
		url: 'search_task2',
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
			var hasRecords = 0;
			jQuery(xml).find('record').each(
				function()
				{
					var _lastname = jQuery(this).find('lastname').text(),
						_firstname = jQuery(this).find('firstname').text(),
						_middlename = jQuery(this).find('middlename').text(),
						_fromlogin = jQuery(this).find('fromlogin').text(),
						_to = jQuery(this).find('to').text(),
						_subject = jQuery(this).find('subject').text(),
						_message = jQuery(this).find('message').text(),
						_dt = jQuery(this).find('dt').text();
					
					jQuery('<tr></tr>').html('<td>'+_lastname+'</td><td>'+_firstname+'</td><td>'+_middlename+'</td><td>'+_fromlogin+'</td><td>'+_to+'</td><td>'+_subject+'</td><td>'+_message+'</td><td>'+_dt+'</td>').appendTo('#search_res');
						
					hasRecords = 1;
				});
				if (hasRecords == 1){
					$('#search_res').removeClass("hidden");
					$('#nofind_msg').addClass("hidden");
				} else {
					$('#search_res').addClass("hidden");
					$('#nofind_msg').removeClass("hidden");
				}
		}
	}).fail(function () {
			alert('Ошибка отправки запроса');
	});
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
	
	<div id="login_div" class="hidden">
		<span style="color: gray">Здраствуйте, ${userLogin}!</span>
		<a href="logout.jsp">Выйти</a> 
	</div>
    <h1>Поиск сообщений</h1>

    <form id="request_form">
		<label for="client">Выберите получателя:</label>
		<select name="client" id="client">
			<option value="0" selected>-все-</option>
		</select>
    </form>
	<button onclick="search()">Найти</button>
	
<br><br>
	<table class="hidden" border="1" id="search_res">
	  <tr>
		<th>Фамилия</th>
		<th>Имя</th>
		<th>Отчество</th>
		<th>Логин отправителя</th>
		<th>Получатель</th>
		<th>Тема</th>
		<th>Сообщение</th>
		<th>Дата, время</th>
	  </tr>
	</table>
	
	<span id="nofind_msg" class="hidden" style="color: red">Ничего не найдено</span>
	
</body>
</html>