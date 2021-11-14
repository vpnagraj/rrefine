#' Helper function to configure and call path to OpenRefine
#'
#' This function is a helper that is used throughout `rrefine` to construct the path to the OpenRefine instance. By default this points to the localhost (`http://127.0.0.1:3333`).
#'
#' @param host Host for running OpenRefine instance; default is `http://127.0.0.1`
#' @param port Port number for running OpenRefine instance; default is `3333`
#' @return Character vector with path to running OpenRefine instance
#' @md

refine_path <- function(host = "http://127.0.0.1", port ="3333") {

    paste0(host, ":", port)

}

#' Get all project metadata from OpenRefine
#'
#' This function is included internally to help retrieve metadata from the running OpenRefine instance. The query uses the OpenRefine API `/command/core/get-all-project-metadata` endpoint.
#'
#' @param ... Additional parameters to be inherited by \code{\link{refine_path}}; allows users to specify `host` and `port` arguments if the OpenRefine instance is running at a location other than `http://127.0.0.1:3333`
#' @references \url{https://docs.openrefine.org/technical-reference/openrefine-api#get-all-projects-metadata}
#' @return Parsed `list` object with all project metadata including identifiers, names, dates of creation and modification, tags and more.
#' @md
#' @export
#' @examples
#' \dontrun{
#' refine_metadata()
#' }
#'

refine_metadata <- function(...) {

    query <- refine_query("get-all-project-metadata", use_token = FALSE, ...)
    httr::content(httr::GET(query))

}

#' Helper function to get OpenRefine project.id by project.name
#'
#' For functions that allow either a project name or id to be passed, this function is used internally to resolve the project id from name if necessary. It also validates that values passed to the `project.id`` argument match an existing project id in the running OpenRefine instance.
#'
#' @param project.name Name of project
#' @param project.id Unique identifier for project
#' @param ... Additional parameters to be inherited by \code{\link{refine_path}}; allows users to specify `host` and `port` arguments if the OpenRefine instance is running at a location other than `http://127.0.0.1:3333`
#' @return Unique id of project
#' @md

refine_id <- function(project.name, project.id, ...) {

    ## check if both arguments are NULL and stop() if so
    if (is.null(project.name) & is.null(project.id)){
        stop("You must supply either a project name or project id")
    }

    ## get metedata for running instance
    ## this will be used to validate the project id ...
    ## and find the id by name if project id is passed in
    metadata <- refine_metadata(...)

    if (!is.null(project.id)) {

        ## validate that if a project id is passed in then it actually exists in OpenRefine
        if(project.id %in% names(metadata$projects)) {
            project.id <- project.id
        } else {
            stop(sprintf("There are no projects that match the id '%s'",
                         project.id))
        }

    ## if project id is null then try to get the id from name
    } else {
        tmp <- lapply(metadata$projects, function(x) x$name)
        id <- names(tmp[tmp == project.name])
        if (length(id) == 1) {
            project.id <- id
        } else if (length(id) == 0) {
            stop(sprintf("There are no projects found named '%s' ... try adjusting the project.name argument or use project.id",
                         project.name))
        } else {
            stop(sprintf("There are multiple projects named '%s' ... try adding a project.id",
                         project.name))
        }
    }
}

#' Helper function to check if `rrefine` can connect to OpenRefine
#'
#' This function will check that `rrefine` is able to access the running OpenRefine instance. Used internally prior to upload, delete, and export operations.
#' @param ... Additional parameters to be inherited by \code{\link{refine_path}}; allows users to specify `host` and `port` arguments if the OpenRefine instance is running at a location other than `http://127.0.0.1:3333`
#' @md
#' @return Error message if `rrefine` is unable to connect to OpenRefine, otherwise is invisible

refine_check <- function(...) {

    tryCatch(
        expr = httr::GET(refine_path(...)),
        error = function(e)
            cat("rrefine is unable to connect to OpenRefine ... make sure OpenRefine is running"))

    invisible()

}

#' Helper function to retrieve CSFR token
#'
#' @param ... Additional parameters to be inherited by \code{\link{refine_path}}; allows users to specify `host` and `port` arguments if the OpenRefine instance is running at a location other than `http://127.0.0.1:3333`
#'
#' @return Character vector with OpenRefine CSFR token
#' @md
#'
refine_token <- function(...) {

    ## before proceeding check that OpenRefine is running
    refine_check(...)
    query <- refine_query("get-csrf-token", use_token = FALSE, ...)
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
#' @param ... Additional parameters to be inherited by \code{\link{refine_path}}; allows users to specify `host` and `port` arguments if the OpenRefine instance is running at a location other than `http://127.0.0.1:3333`
#' @return Character vector with query based on parameter entered
#'
#' @md
#'
#'
refine_query <- function(query, use_token = TRUE, ...) {

    base_query <- paste0(refine_path(...),
                         "/command/core/",
                         query)
    if(use_token) {
        ## get token request response
        token <- refine_token(...)

        query <- paste0(base_query,
                        "?csrf_token=",
                        token)
    } else {
        query <- base_query
    }

    return(query)

}
