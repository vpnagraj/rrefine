#' Delete project from OpenRefine
#'
#' This function allows users to delete a project in OpenRefine by name or unique project identifier. By default users are prompted to confirm deletion. The function wraps the OpenRefine API `/command/core/delete-project` query.
#'
#' @param project.name Name of project to be deleted
#' @param project.id Unique identifier for open refine project to be deleted
#'
#' @return Operates as a side-effect to delete the project. Issues a message that the project has been deleted.
#' @references \url{https://github.com/OpenRefine/OpenRefine/wiki/OpenRefine-API#delete-project}
#' @export
#' @md
#' @examples
#' \dontrun{
#' refine_delete(project.name = "foo")
#' refine_delete(project.id = 1901017388690)
#' refine_delete(project.name = "Untitled", project.id = 1901018888332)
#' }
#'
refine_delete <- function(project.name = NULL, project.id = NULL) {

    ## check that OpenRefine is running
    refine_check()

    ## resolve id for project to delete from either project.name or the project.id args
    project.id <- refine_id(project.name, project.id)
    ## prompt user to confirm deletion
    x <- readline(prompt = "Are you sure you want to delete this project? (Y/N): ")

    if(x == "Y") {
        query <- refine_query("delete-project", use_token = TRUE)
        httr::POST(
            query,
            body = list(project = project.id),
            encode = "form")
        message(sprintf("Project %s deleted", project.id))
    } else
        stop("Aborting delete process")

}
