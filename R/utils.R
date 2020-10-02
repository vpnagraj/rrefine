#' Helper function to configure and call path to OpenRefine
#'
#' @param host Host for running OpenRefine instance; default is `http://127.0.0.1`
#' @param port Port number for running OpenRefine instance; default is `3333`
#' @return Path to running

refine_path <- function(host = "127.0.0.1", port ="3333") {

    paste0("http://", host, ":", port)

}

#' Get all project metadata from OpenRefine
#'
#' This function is included internally to help retrieve metadata from the running OpenRefine instance. The query uses the OpenRefine API `/command/core/get-all-project-metadata` endpoint.
#' @md
#' @references \url{https://github.com/OpenRefine/OpenRefine/wiki/OpenRefine-API#get-all-projects-metadata}
#' @return Parsed `list` object with all project metadata including identifiers, names, dates of creation and modification, tags and more.
#' @examples
#' \dontrun{
#' refine_metadata()
#' }
#'

refine_metadata <- function() {

    query <- refine_query("get-all-project-metadata", use_token = FALSE)
    httr::content(httr::GET(query))

}

#' Helper function to get OpenRefine project.id by project.name
#'
#' @param project.name Name of project
#' @param project.id Unique identifier for project
#' @return Unique id of project

refine_id <- function(project.name, project.id) {

    if (is.null(project.name) & is.null(project.id)){
        stop("You must supply either a project name or project id")
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
            stop(sprintf("There are no projects found named '%s' ... try adjusting the project.name argument or use project.id",
                         project.name))
        } else {
            stop(paste0("There are multiple projects named '%s' ... try adding a project.id",
                        project.name))
        }
    }
}

#' Helper function to check if `rrefine` can connect to OpenRefine
#'
#' @md
#' @return Error message if `rrefine` is unable to connect to OpenRefine, otherwise is invisible

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
#' Starting with the path to the running instance, this function will add a query command and (optionally) a CSFR token with \code{\link{refine_token}}
#'
#' @param query Character vector specifying the API endpoint to query
#' @param use_token Boolean indicating whether or not the query string should include a CSRF Token (see \code{\link{refine_token}}; default is `TRUE`
#' @return Character vector with query based on parameter entered
#'
#' @md
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
