package ru.shherbakov_aa.WorkTest;

public class Database {

	public final static String dbUrl = "jdbc:postgresql://{server}:{port}/{dbname}"; //DB string to connect
	public final static String dbLogin = "login"; //DB login
	public final static String dbPassword = "password"; //DB password

	public final static String sqlTask1GetCars = "select cm.id, cb.name || ' ' || cm.name as name from t_carmodels cm left join t_carbrands cb on cm.brand_id = cb.id order by cb.name, cm.name";

	public final static String sqlTask1GetCities = "select id, name from t_cities order by name";
	
	public final static String sqlTask1Search = new StringBuilder()
		.append("select\n")
	    .append("p.last_name, p.first_name, p.middle_name, ci.name as city_name, cb.name || ' ' || cm.name as car_model, cc.name as color_name, c.reg_number\n")
	    .append("from cars c\n")
	    .append("left join t_carmodels cm on c.model_id = cm.id\n")
	    .append("left join t_carbrands cb on cm.brand_id = cb.id\n")
	    .append("left join t_carcolors cc on c.color_id = cc.id\n")
	    .append("left join persons p on c.owner_id = p.id\n")
	    .append("left join t_cities ci on p.city_id = ci.id\n")
	    .append("where\n")
	    .append("(length(?) = 0 or trim(lower(?)) = trim(lower(p.last_name)))\n")
	    .append("and (length(?) = 0 or trim(lower(?)) = trim(lower(p.first_name)))\n")
	    .append("and (length(?) = 0 or trim(lower(?)) = trim(lower(p.middle_name)))\n")
	    .append("and (? = 0 or ? = p.city_id)\n")
	    .append("and (? = 0 or ? = c.model_id)\n")
	    .append("order by p.last_name, p.first_name, p.middle_name, ci.name, cb.name || ' ' || cm.name, cc.name, c.reg_number\n")
	    .toString();
	
	public final static String sqlTask2GetClients = "select id, last_name || ' ' || first_name || coalesce(' ' || nullif(middle_name, ''), '') || ' (' || email || ')' as name from clients";
	
	public final static String sqlTask2Search = new StringBuilder()	
       	.append("select\n")
		.append("r.from_first_name, r.from_last_name, r.from_middle_name, coalesce(w.login, 'Гость') as from_login,\n")
		.append("c.last_name || ' ' || c.first_name || coalesce(' ' || nullif(c.middle_name, ''), '') || ' (' || c.email || ')' as to_client,\n")
		.append("r.subject,\n")
		.append("r.message,\n")
		.append("to_char(dt, 'dd.mm.yyyy hh24:mi') as created\n")
		.append("from requests r\n")
		.append("left join clients c on r.to_client_id = c.id\n")
		.append("left join webusers w on r.from_webuser_id = w.id\n")
       	.append("where (? = 0 or ? = r.to_client_id)\n")
       	.append("order by r.dt\n")
       	.toString();

   	public final static String sqlTask2InsertRequests = "insert into requests(from_first_name, from_last_name, from_middle_name, from_webuser_id, to_client_id, subject, message) values (?, ?, ?, (select id from webusers where active and jsessionid = ?), ?, ?, ?)";
   	
   	public final static String sqlTask2CheckWebusersExist = "select login from webusers where login = ? limit 1";
   	
   	public final static String sqlTask2CheckLoginPassword = "select login from webusers where active and login = ? and pwd = ? limit 1";
   	
   	public final static String sqlTask2SetWebuserSessionid = "update webusers set jsessionid = null where jsessionid = ? and login <> ?; update webusers set jsessionid = ?, last_login_dt = now() where login = ?";
   	
   	public final static String sqlTask2InsertWebusers = "update webusers set jsessionid = null where jsessionid = ? and login <> ?; insert into webusers(login, pwd, is_operator, jsessionid, last_login_dt) values (?, ?, ?, ?, now())";
	
   	public final static String sqlTask2CheckWebusersSessionid = "select login, is_operator from webusers where active and jsessionid = ? limit 1";
}


