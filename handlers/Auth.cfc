/**
 * Authentication Handler
 */
component extends="coldbox.system.RestHandler" {

	// Injection
	property name="userService" inject="UserService";
	property name="wirebox" inject="wirebox";
	property name="bcrypt" inject="BCrypt@BCrypt";

	/**
	 * Login a user into the application
	 *
	 * @x           -route          (POST) /api/login
	 * @requestBody ~auth/login/requestBody.json
	 * @response    -default ~auth/login/responses.json##200
	 * @response    -401     ~auth/login/responses.json##401
	 */
	function login( event, rc, prc ){
		param rc.email = "";
		param rc.password = "";

		// var user = userService.retrieveUserByEmail(rc.email).getMemento();

		// Use checkPassword to verify the password
		// if (!bcrypt.checkPassword(rc.password, user.password)) {
		// 	event.getResponse().setError(true).addMessage("Invalid password");
		// 	return;
		// }
		
		var token = jwtAuth().attempt(rc.email, rc.password);

		event
			.getResponse()
			.setData(token)
			.addMessage(
				"Bearer token created and it expires in #jwtAuth().getSettings().jwt.expiration# minutes"
			);
	}

	/**
	 * Register a new user in the system
	 *
	 * @x           -route          (POST) /api/register
	 * @requestBody ~auth/register/requestBody.json
	 * @response    -default ~auth/register/responses.json##200
	 * @response    -400     ~auth/register/responses.json##400
	 */
	function register( event, rc, prc ){
		param rc.name = "";
		param rc.email = "";
		param rc.password = "";
		param rc.role_id = 2;

		var hashedPassword = bcrypt.hashPassword(rc.password);

		var user = userService.create({
			name: rc.name,
			email: rc.email,
			password: hashedPassword,
			role_id: rc.role_id,
			created_at: now()
		});

		event
			.getResponse()
			.setData({
				"token": jwtAuth().fromUser(user),
				"user": user.getMemento()
			})
			.addMessage(
				"User registered correctly and Bearer token created and it expires in #jwtAuth().getSettings().jwt.expiration# minutes"
			);
	}

	/**
	 * Logout a user
	 *
	 * @x        -route          (POST) /api/logout
	 * @security bearerAuth,ApiKeyAuth
	 * @response -default ~auth/logout/responses.json##200
	 * @response -500     ~auth/logout/responses.json##500
	 */
	function logout( event, rc, prc ){
		jwtAuth().logout();
		event.getResponse().addMessage("Successfully logged out");
	}

}