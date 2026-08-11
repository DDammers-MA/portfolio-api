component extends="coldbox.system.RestHandler" {



    // property name="qb" inject="provider:QueryBuilder@qb";
property name="qb" inject="QueryBuilder@qb";

function onInvalidHTTPMethod( faultAction, event, rc, prc ){
    event.getResponse().setStatus(405);
    event.getResponse().setData({
        "error": true,
        "message": "HTTP method not allowed for this endpoint"
    });
}

    function index(event, rc, prc){
var q = qb.from("projects as p")
    .select([
        "p.id", "p.title", "p.subTitle", "p.description",
        "p.main_image", "p.sub_image_1", "p.sub_image_2", "p.sub_image_3",
        "p.created_at", "p.created_by", "p.github_url", "p.live_url"
    ])
    .selectRaw("GROUP_CONCAT(DISTINCT f.framework_name) as frameworks")
    .selectRaw("GROUP_CONCAT(DISTINCT s.name) as skills")
    .leftJoin("project_frameworks as pf", "pf.project_id", "p.id")
    .leftJoin("frameworks as f", "f.id", "pf.framework_id")
    .leftJoin("skills as s", "s.id", "f.skill_id")
    .groupBy("p.id")
    .orderBy("p.id", "desc")


if (rc.keyExists("skill_id") && len(rc.skill_id)) {
    q.where("s.id", rc.skill_id);
}

if (rc.keyExists("frameworks") && len(rc.frameworks)) {
 q.whereIn("f.id", listToArray(rc.frameworks));
}




var projects = q.get();

  event.getResponse().setData(isNull(projects) ? [] : projects);
    }

    

    function featured(event, rc, prc){
//   var projects = queryExecute("
//     SELECT 
//         p.id, p.title, p.subTitle, p.description,
//         p.main_image, p.sub_image_1, p.sub_image_2, p.sub_image_3,
//         p.created_at, p.created_by,
//         GROUP_CONCAT(DISTINCT f.framework_name) AS frameworks,
//         GROUP_CONCAT(DISTINCT s.name) AS skills
//     FROM projects p
//     LEFT JOIN project_frameworks pf ON pf.project_id = p.id
//     LEFT JOIN frameworks f ON f.id = pf.framework_id
//     LEFT JOIN skills s ON s.id = f.skill_id
//     WHERE (:skill_id IS NULL OR s.id = :skill_id)
//     GROUP BY p.id
//     ORDER BY p.id DESC
//     LIMIT 6
// ", {
//     skill_id: rc.keyExists("skill_id") ? rc.skill_id : javacast("null", "")
// });

var q = qb.from("projects as p")
    .select([
        "p.id", "p.title", "p.subTitle", "p.description",
        "p.main_image", "p.sub_image_1", "p.sub_image_2", "p.sub_image_3",
        "p.created_at", "p.created_by"
    ])
    .selectRaw("GROUP_CONCAT(DISTINCT f.framework_name) as frameworks")
    .selectRaw("GROUP_CONCAT(DISTINCT s.name) as skills")
    .leftJoin("project_frameworks as pf", "pf.project_id", "p.id")
    .leftJoin("frameworks as f", "f.id", "pf.framework_id")
    .leftJoin("skills as s", "s.id", "f.skill_id")
    .groupBy("p.id")
    .orderBy("p.id", "desc")
    .limit(6);

if (rc.keyExists("skill_id") && len(rc.skill_id)) {
    q.where("s.id", rc.skill_id);
}

var projects = q.get();

    event.getResponse().setData(projects);

    // writeDump(var=projects.get(), label="rc", abort=true);
        
        
        // Transform the data to include frameworks
        
        // var results = projects.get();


        
        // event.getResponse().setData(results);
    }
    
function create(event, rc, prc){

    transaction {
    
        // 1. Create and populate entity properly
        var project = getInstance("Projects");
        populateModel(project);

        // 2. Validate
        var vResults = validateModel(project);

        if ( vResults.hasErrors() ) {
            transactionRollback();
            event.getResponse().setStatus(400);
            event.getResponse().setData(vResults.getAllErrors());
            return;
        }

        // 3. Save project
        project.save();

        // 4. OPTIONAL: attach frameworks (to match your SHOW query structure)
        if ( structKeyExists(rc, "frameworks") && len(rc.frameworks) ) {

            // expecting rc.frameworks = [1,2,3] or "1,2,3"
            var frameworkList = isArray(rc.frameworks)
                ? rc.frameworks
                : listToArray(rc.frameworks);

            for (var fwId in frameworkList) {
                queryExecute(
                    "INSERT INTO project_frameworks (project_id, framework_id)
                     VALUES (:pid, :fid)",
                    {
                        pid: project.getId(),
                        fid: fwId
                    }
                );
            }
        }

        // 5. Response (match show() style more closely)
        event.getResponse().setStatus(201);
        event.getResponse().setData({
            "id": project.getId(),
            "title": project.getTitle(),
            "subTitle": project.getSubTitle(),
            "description": project.getDescription(),
            "main_image": project.getMain_image(),
            "created_at": project.getCreated_at(now())
        });

    } // transaction
}


/**
 * update
 */
function update(event, rc, prc){

    transaction {

      var project = getInstance("Projects").findOrFail(rc.id);
        
        // Manually load by id via QB
        var existing = qb.from("projects").where("id", rc.id).first();

        if ( isNull(existing) || existing.isEmpty() ) {
            transactionRollback();
            event.getResponse().setStatus(404);
            event.getResponse().setData({ "message": "Project not found" });
            return;
        }

        populateModel(
            model   = project,
            exclude = "frameworks,id,created_at"
        );

        // Force the id so it updates instead of inserts
        project.setId(rc.id);

        var vResults = validateModel(project);

        if ( vResults.hasErrors() ) {
            transactionRollback();
            event.getResponse().setStatus(400);
            event.getResponse().setData(vResults.getAllErrors());
            return;
        }
        project.setUpdated_at(now());
        project.save();

        queryExecute(
            "DELETE FROM project_frameworks WHERE project_id = :pid",
            { pid: rc.id }
        );

        if ( structKeyExists(rc, "frameworks") && len(rc.frameworks) ) {
            var frameworkList = isArray(rc.frameworks)
                ? rc.frameworks
                : listToArray(rc.frameworks);

            for (var fwId in frameworkList) {
                queryExecute(
                    "INSERT INTO project_frameworks (project_id, framework_id)
                     VALUES (:pid, :fid)",
                    { pid: rc.id, fid: fwId }
                );
            }
        }

        event.getResponse().setStatus(200);
        event.getResponse().setData({
            "id":          project.getId(),
            "title":       project.getTitle(),
            "subTitle":    project.getSubTitle(),
            "description": project.getDescription(),
            "main_image":  project.getMain_image(),
            "updated_at":  now()
        });

    }
}


/**
 * delete
 */
	function delete(event, rc, prc) {
		var project = getInstance( "Projects" ).findOrFail(rc.id);
            // writeDump(var=projects.get(), label="rc", abort=true);

		project.delete()
		event.getResponse().setData({ "result": 1 });
	}
// function upload(event, rc, prc){
//     var uploadDir = expandPath("/assets/uploads/projects/");

//     if (!directoryExists(uploadDir)) {
//         directoryCreate(uploadDir);
//     }

//     var fileResult = fileUpload(
//         destination = uploadDir,
//         fileField    = "file",
//         nameConflict = "makeUnique"
//     );

//     var url = "/assets/uploads/projects/" & fileResult.serverFile;

//     event.getResponse().setData({
//         filename = fileResult.serverFile,
//         url      = url
//     });
// }
}