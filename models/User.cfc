/**
 * A user in the system.
 *
 * This user is based off the Auth User included in cbsecurity, which implements already several interfaces and properties.
 * - https://coldbox-security.ortusbooks.com/usage/authentication-services#iauthuser
 * - https://coldbox-security.ortusbooks.com/jwt/jwt-services#jwt-subject-interface
 *
 * It also leverages several delegates for Validation, Population, Authentication, Authorization and JWT Subject.
 */
component
	table = "users"
	accessors     ="true"
    extends="quick.models.BaseEntity"
	transientCache="false"
	delegates     ="
		Validatable@cbvalidation,
		Population@cbDelegates,
		Auth@cbSecurity,
		Authorizable@cbSecurity,
		JwtSubject@cbSecurity
	"
{
	property name="wirebox" inject="wirebox" persistent="false";
	property name="id" fieldtype="id";
    property name="name";
    property name="email"  accessed="true";
    property name="password" accessed="true";

    property name="created_at";
    property name="last_login";
    property name="role_id";

	function getPermissions() {
		// Logic to get permissions
		return ['read', 'write', 'execute'];
	}

	function getRoles() {
	
			return ['user'];
	
	}


	this.memento = {
		defaultIncludes: [
			"id",
			"name",
			"email",
			"password",
			"created_at",
			"last_login",
			"role_id"
		],
		profiles: {
			detail: {
				defaultIncludes: []
			}
		}
	};

	this.constraints = {
		name: { required: true, type: "string" },
		// email: { required: true, type: "email" },
		password: { required: true, type: "string" },
		role_id: { required: true, type: "numeric" }
	};

	/**
	 * Constructor
	 */
	function init(){
		super.init();
		return this;
	}
}