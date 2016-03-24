#' delete project from open refine
#'
#' @param project.name name of project to be deleted
#' @param project.id unique identifier for open refine project to be deleted
#' @export
#' @examples
#' \dontrun{
#' refine_delete(project.name = "foo")
#' refine_delete(project.id = 1901017388690)
#' }
#'
refine_delete <- function(project.name = NULL, project.id = NULL) {

    if (is.null(project.name) & is.null(project.id)){

        stop("you must supply either a project name or project id")

    }

    if (!is.null(project.id)) {

        project.id <- project.id

    } else {

        resp <- refine_metadata()

        name <- NULL

        id <- names(rlist::list.mapv(
            rlist::list.filter(resp[["projects"]],
                               name == project.name),
            name))

        if (length(id) == 1) {

            project.id <- id

        } else if (length(id) == 0) {

            stop(paste0("there are no projects found named '",
                        project.name,
                        "' ... try adjusting the project.name argument or use project.id"))

        } else {

            stop(paste0("there are mulitple projects named '",
                        project.name,
                        "' ... try addding a project.id"))

        }
    }

    x <- readline(prompt = "are you sure you want to delete this project? (Y/N): ")

    if(x == "Y") {
        httr::POST(
            paste0(refine_path(), "/", "command/core/delete-project"),
            body = list(project = project.id),
            encode = "form")
        message("project deleted")
    } else
        stop("aborting delete process")

}
