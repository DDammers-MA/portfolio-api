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
	table = "projects"
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
    property name="title";
    property name="subTitle";
    property name="description";

    
    // Image fields
    property name="main_image";
    property name="sub_image_1";
    property name="sub_image_2";
    property name="sub_image_3";
    
    property name="created_at";
	property name="created_by";
	property name="updated_at";
	    property name="github_url";
		    property name="live_url";



	this.memento = {
		defaultIncludes: [
			"id",
			"title",
			"subTitle",
			"description",
	
			"main_image",
			"sub_image_1",
			"sub_image_2",
			"sub_image_3",
			"created_at",
			"created_by",
			"updated_at",
			"github_url",
			"live_url"
		],
		profiles: {
			detail: {
				defaultIncludes: []
			}
		}
	};

    

	this.constraints = {
		title: { required: true, type: "string" },
		subTitle: { required: true, type: "string" },
		description: { required: true, type: "string" },
	
	};

	/**
	 * Constructor
	 */
	function init(){
		super.init();
		return this;
	}
}