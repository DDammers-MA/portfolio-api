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
	table = "Frameworks"
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
    property name="skill_id";
    property name="framework_name";




	this.memento = {
		defaultIncludes: [
			"id",
            "skill_id",
            "framework_name"
		],
		profiles: {
			detail: {
				defaultIncludes: []
			}
		}
	};

    

	this.constraints = {
	
	};

	/**
	 * Constructor
	 */
	function init(){
		super.init();
		return this;
	}
}