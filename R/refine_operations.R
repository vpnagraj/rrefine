#' Title
#'
#' @param project.name Name of project to be exported
#' @param project.id Unique identifier for project to be exported
#' @param operations List
#' @param ... Additional parameters to be inherited by \code{\link{refine_path}}; allows users to specify `host` and `port` arguments if the OpenRefine instance is running at a location other than `http://127.0.0.1:3333`
#'
#' @return
#' @export
#'
#' @examples
refine_operations <- function(project.name = NULL, project.id = NULL, operations, ...) {

    ## check that OpenRefine is running
    refine_check(...)

    ## resolve id for project to export from either project.name or the project.id args
    project.id <- refine_id(project.name, project.id, ...)

    ## define upload query
    query <- refine_query("apply-operations", use_token = TRUE, ...)

    ## add project id
    query <-
        paste0(query,
               "&project=",
               project.id)

    ## coerce list of operations to json
    operations <- jsonlite::toJSON(operations, pretty = TRUE, auto_unbox = TRUE)

    httr::POST(query,
               body = list(operations = operations),
               encode = "form",
               httr::content_type('application/x-www-form-urlencoded'))


}
