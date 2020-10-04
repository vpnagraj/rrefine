#' Delete project from OpenRefine
#'
#' This function allows users to delete a project in OpenRefine by name or unique project identifier. By default users are prompted to confirm deletion. The function wraps the OpenRefine API `/command/core/delete-project` query.
#'
#' @param project.name Name of project to be deleted
#' @param project.id Unique identifier for open refine project to be deleted
#' @param force Boolean indicating whether or not the prompt to confirm deletion should be skipped; default is `FALSE`
#' @param ... Additional parameters to be inherited by \code{\link{refine_path}}; allows users to specify `host` and `port` arguments if the OpenRefine instance is running at a location other than `http://127.0.0.1:3333`
#' @return Operates as a side-effect to delete the project. Issues a message that the project has been deleted.
#' @references \url{https://github.com/OpenRefine/OpenRefine/wiki/OpenRefine-API#delete-project}
#' @export
#' @md
#' @examples
#' \dontrun{
#' fp <- system.file("extdata", "lateformeeting.csv", package = "rrefine")
#' refine_upload(fp, project.name = "lfm")
#' refine_delete("lfm", force = TRUE)
#' }
#'
refine_delete <- function(project.name = NULL, project.id = NULL, force = FALSE, ...) {

    ## check that OpenRefine is running
    refine_check(...)

    ## resolve id for project to delete from either project.name or the project.id args
    project.id <- refine_id(project.name, project.id, ...)

    query <- refine_query("delete-project", use_token = TRUE, ...)

    ## if the force option is used skip the user prompt and run the delete query
    if(force) {
        httr::POST(
            query,
            body = list(project = project.id),
            encode = "form")
      ## otherwise prompt the user to confirm that they want to delete the project
    } else {
        ## prompt user to confirm deletion
        x <- readline(prompt = "Are you sure you want to delete this project? (Y/N): ")

        if(x == "Y") {
            httr::POST(
                query,
                body = list(project = project.id),
                encode = "form")
        } else
            stop("Aborting delete process")
    }

    if(!project.id %in% names(refine_metadata(...)$projects)) {
        message(sprintf("Project %s deleted", project.id))
    } else {
        stop(sprintf("Project %s was not successfully deleted."))
    }

}
