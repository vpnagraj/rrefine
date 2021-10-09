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


#' Title
#'
#' @param column Name of the column to be removed
#' @param project.name Name of project to be exported
#' @param project.id Unique identifier for project to be exported
#' @param ... Additional parameters to be inherited by \code{\link{refine_path}}; allows users to specify `host` and `port` arguments if the OpenRefine instance is running at a location other than `http://127.0.0.1:3333`
#'
#' @return
#' @export
#'
refine_remove_column <- function(column, project.name = NULL, project.id = NULL, ...) {

    refine_operations(project.name = project.name,
                      project.id = project.id,
                      operations = list(list(op = "core/column-removal", columnName = column)),
                      ...)
}

#' Title
#'
#' @param column Name of the column to be removed
#' @param project.name Name of project to be exported
#' @param project.id Unique identifier for project to be exported
#' @param ... Additional parameters to be inherited by \code{\link{refine_path}}; allows users to specify `host` and `port` arguments if the OpenRefine instance is running at a location other than `http://127.0.0.1:3333`
#'
#' @return
#' @export
#'
refine_add_column <- function(new_column, new_column_index, base_column = NULL, value, on_error = "set-to-blank", description = NULL, project.name = NULL, project.id = NULL, ...) {

    ops <-
        list(
            op = "core/column-addition",
            description = description,
            engineConfig = list(mode = "row-based", facets = list()),
            newColumnName = new_column,
            columnInsertIndex = new_column_index,
            expression = value,
            onError = on_error)

    if(!is.null(base_column)) {
        ops <- c(ops, baseColumnName = base_column)
    }

    refine_operations(project.name = project.name,
                      project.id = project.id,
                      operations = list(ops),
                      ...)
}
