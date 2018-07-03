<html>
  <head>
  <meta charset="UTF-8">
  <title>Авторизация пользоваателя</title>
  </head>
  <body>
	<script type="text/javascript" src="jquery-1.12.4.min.js"></script>
	<script type="text/javascript" src="js.cookie.min.js"></script>
    <script>
		$(document).ready(function(){ 
			Cookies.remove('task1FlushSession');
		});
	
		function submitForm() {
			if(!$("#remember").is(":checked"))
				Cookies.set('task1FlushSession', '1');
		
			$("#loginForm").submit();
		}
	</script>
	<h2>Авторизация пользоваателя</h2>
    <form name="loginForm" id="loginForm" method="POST" action="j_security_check">
        <p>Логин: <input type="text" name="j_username" size="20"/></p>
        <p>Пароль: <input type="password" size="20" name="j_password"/></p>
		<p>Запомнить <input type="checkbox" name="remember" value="1" id="remember" checked></p>
    </form>
	<button onclick="submitForm()">Войти</button>
  </body>
</html> 