/**
 * This service provides user authentication, retrieval and much more.
 * Implements the CBSecurity IUserService: https://coldbox-security.ortusbooks.com/usage/authentication-services#iuserservice
 */
component accessors="true" singleton {

	property name="wirebox" inject="wirebox";
	property name="bcrypt" inject="BCrypt@BCrypt";

	/**
	 * Verify if the incoming username/password are valid credentials.
	 *
	 * @name The username
	 * @password The password
	 */
	function isValidCredentials( required email, required password ){
		var result = false; 
		// Retrieve the user by email
		var user = retrieveUserByEmail(arguments.email ).getMemento();

		// writeDump(var=oTarget, abort=true, label="isValidCredentials");
		// writeDump(var=user, abort=true, label="user.password");
		
		if (isNull(user)) {
			
			return false;
		}

			// Use checkPassword to verify the password
		if (!bcrypt.checkPassword(arguments.password, user.password)) {
			// event.getResponse().setError(true).addMessage("Invalid password");
			return false;
		}


		return true;
	}

	/**
	 * Create a new user
	 *
	 * @userData Struct containing user data (name, email, password, role)
	 *
	 * @return User entity
	 */
	 
	function create( required struct userData ){
		// var hashedPassword = bcrypt.hashPassword(userData.password);


		// Create a new User instance
		var user = wirebox.getInstance("User")
			.setName(userData.name)
			.setEmail(userData.email)
			.setPassword(userData.password)
			.setRole_id(userData.role_id	) // Ensure correct method is used
			.setCreated_at(now());

		// Validate the user
		user.validateOrFail();

		// Save the user to the database
		user.save();

		// registerCustomer(user);

		return user;
	}

	/**
	 * Retrieve a user by email
	 *
	 * @return User that implements JWTSubject and/or IAuthUser
	 */
	function retrieveUserByEmail( required email ){
		return wirebox.getInstance("User").where("email", arguments.email).firstOrFail();
	}

	function retrieveUserByUsername( required email ){
		// Log the email being used for retrieval
		// writeDump(var=email, label="Email for retrieveUserByEmail");

		var user = wirebox.getInstance("User").where("email", arguments.email).first();

 var userMemento = user.getMemento(); 
     user.password = userMemento.password;
			userAsmemento = user.getMemento();

		// Log the user object retrieved
		// writeDump(var=user, abort=true, label="User retrieved by email");
		// writeDump(var=userAsmemento, abort=true, label="User retrieved by email");

		return user;
	}
	/**
	 * Retrieve a user by unique identifier
	 *
	 * @id The unique identifier
	 *
	 * @return User that implements JWTSubject and/or IAuthUser
	 */
	User function retrieveUserById( required id ){
		return wirebox.getInstance("User").findOrFail( arguments.id );
	}

	// function registerCustomer( required User user) {
  

	// var firstName = listFirst(user.getName(), " ");
    // var lastName = listRest(user.getName(), " ");

	//   if (!len(trim(lastName))) {
    //     lastName = "Unknown";
    // } 
 
	// 	// Create a new Customer instance
	//  var customer = wirebox.getInstance("Customers")
    //     .setFirst_name(firstName)
    //     .setLast_name(lastName)	
	// 	.setCreated_at(now())
	// 	.setUser_id(user.getId());

    // //     // Validate the customer
    //     customer.validateOrFail();
	// 	// writeDump(var=customer, abort=true, label='userData');

    // //     // Save the customer to the database
    //     customer.save();
	// }
}