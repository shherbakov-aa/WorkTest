<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Поиск человека</title>
</head>
<body>

<style type="text/css">
	.hidden { display:none; }
</style>

<script type="text/javascript" src="jquery-1.12.4.min.js"></script>
<script type="text/javascript" src="js.cookie.min.js"></script>

<script>
$(document).ready(function(){ 
	getCities();
	getCars();
	
	if ('${userLogin}' != '')
		$('#login_div').removeClass("hidden");
	
	
	if ('${needAuth}' == '1' && Cookies.get('task1FlushSession') == '1'){
		callLogout();
	}		
});

function callLogout(){
	$.ajax({
			url: 'logout.jsp',
			type: 'GET',
			dataType: 'html',
			timeout: 10 * 1000,
			data: ''
		}).then(function (html) {
			Cookies.remove('task1FlushSession');
		}).fail(function () {
			alert('Ошибка сброса сессии');
		});
}

function search() {
	var lastname = $("#lastname").val(),
		firstname = $("#firstname").val(),
		middlename = $("#middlename").val(),
		city = $("#city").val(),
		car = $("#car").val();

	if (!lastname && !firstname && !middlename && city == '0' && car == '0')
		alert('Для поиска необходимо ввести ФИО, либо выбрать город или машину.');
	else{

		$('#search_res tr:not(:first)').remove();
  
		$.ajax({
			url: 'search_task1',
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
							_city = jQuery(this).find('city').text(),
							_car = jQuery(this).find('car').text(),
							_color = jQuery(this).find('color').text();
							_regnumber = jQuery(this).find('regnumber').text();
					
						jQuery('<tr></tr>').html('<td>'+_lastname+'</td><td>'+_firstname+'</td><td>'+_middlename+'</td><td>'+_city+'</td><td>'+_car+'</td><td>'+_color+'</td><td>'+_regnumber+'</td>').appendTo('#search_res');
						
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
}

function getCities() {
	$.ajax({
		url: 'get_cities',
		type: 'POST',
		dataType: 'xml',
		timeout: 10 * 1000,
		data: ''
	}).then(function (xml) {

		var errCode = jQuery(xml).find('errCode').text(),
			errText = jQuery(xml).find('errText').text();
				
		if (errCode != '0') {
			alert ('Ошибка загрузки списка городов. Сервер вернул ошибку code ' +  errCode + ': ' + errText);
		} else {
			jQuery(xml).find('city').each(
				function() {
					var _id = jQuery(this).find('id').text(),
						_name = jQuery(this).find('name').text();
				
					$('#city').append('<option value="' + _id + '">' + _name + '</option>');
				}
			);
		}
	}).fail(function () {
			alert('Ошибка загрузки списка городов');
	});
}

function getCars() {
	$.ajax({
		url: 'get_cars',
		type: 'POST',
		dataType: 'xml',
		timeout: 10 * 1000,
		data: ''
	}).then(function (xml) {

		var errCode = jQuery(xml).find('errCode').text(),
			errText = jQuery(xml).find('errText').text();
				
		if (errCode != '0') {
			alert ('Ошибка загрузки списка машин. Сервер вернул ошибку code ' +  errCode + ': ' + errText);
		} else {
			jQuery(xml).find('car').each(
				function() {
					var _id = jQuery(this).find('id').text(),
						_name = jQuery(this).find('name').text();
				
					$('#car').append('<option value="' + _id + '">' + _name + '</option>');
				}
			);
		}
	}).fail(function () {
			alert('Ошибка загрузки списка машин');
	});
}

</script>
	
	<div id="login_div" class="hidden">
		<span style="color: gray">Здраствуйте, ${userLogin}!</span>
		<a href="logout.jsp">Выйти</a> 
	</div>
    <h1>Поиск человека</h1>

    <form id="request_form">
		<label for="lastname">Фамилия:</label>
        <input type="text" name="lastname" id="lastname" value="">
        <label for="firstname">Имя: </label>
        <input type="text" name="firstname" id="firstname" value="">
		<label for="middlename">Отчество: </label>
		<input type="text" name="middlename" id="middlename" value="">
        <br>
		<label for="city">Город проживания: </label>
		<select name="city" id="city">
			<option value="0" selected>-не выбрано-</option>
		</select>
		<br>
		<label for="car">Машина:</label>
		<select name="car" id="car">
			<option value="0" selected>-не выбрано-</option>
		</select>
    </form>
	<button onclick="search()">Найти</button>
	
<br><br>
	<table class="hidden" border="1" id="search_res">
	  <tr>
		<th>Фамилия</th>
		<th>Имя</th>
		<th>Отчество</th>
		<th>Город</th>
		<th>Модель машины</th>
		<th>Цвет машины</th>
		<th>Гос. номер</th>
	  </tr>
	</table>
	
	<span id="nofind_msg" class="hidden" style="color: red">Ничего не найдено</span>
	
</body>
</html>