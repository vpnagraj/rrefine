#' helper function to configure and call path to OpenRefine
#'
#' @param host host path for your OpenRefine application
#' @param port port number for your OpenRefine application
#' @return path to be executed

refine_path <- function(host = "127.0.0.1", port ="3333") {

    paste0("http://", host, ":", port)

}

#' get all project metadata from OpenRefine
#'
#' @examples
#' \dontrun{
#' refine_metadata()
#' }
#'

refine_metadata <- function() {

    query <- refine_query("get-all-project-metadata", use_token = FALSE)
    httr::content(httr::GET(query))

}

#' helper function to get OpenRefine project.id by project.name
#'
#' @param project.name name of project to be exported or deleted
#' @param project.id unique identifier for project to be exported or deleted
#' @return unique id of project to be exported or deleted

refine_id <- function(project.name, project.id) {

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
            stop(sprintf("There are no projects found named '%s' ... try adjusting the project.name argument or use project.id", project.name))
        } else {
            stop(paste0("There are multiple projects named '%s' ... try adding a project.id", project.name))
        }
    }
}

#' helper function to check if rrefine can connect to OpenRefine
#'
#' @return error message if rrefine is unable to connect to OpenRefine, otherwise is invisible

refine_check <- function() {

    tryCatch(
        expr = httr::GET(refine_path()),
        error = function(e)
            cat("rrefine is unable to connect to OpenRefine ... make sure OpenRefine is running"))

    invisible()

}

#' Helper function to retrieve CSFR token
#'
#' @return Character vector with OpenRefine CSFR token
#'
refine_token <- function() {

    ## before proceeding check that OpenRefine is running
    refine_check()
    query <- refine_query("get-csrf-token", use_token = FALSE)
    ## get token request response
    token <- httr::GET(query)
    ## parse response for token
    httr::content(token)$token
}

#' Helper function to build OpenRefine API query
#'
#' @param query Character vector specifying the API endpoint to query
#' @param use_token Boolean indicating whether or not the query string should include a CSRF Token (see \code{\link{refine_token}}; default is \code{TRUE}
#' @return Character vector with query based on parameter entered
#'
#'
refine_query <- function(query, use_token = TRUE) {

    if(use_token) {
        ## get token request response
        token <- refine_token()

        query <- paste0(refine_path(),
                        "/command/core/",
                        query,
                        "?csrf_token=",
                        token)
    } else {
        query <- paste0(refine_path(),
                        "/command/core/",
                        query)
    }

    return(query)

}
