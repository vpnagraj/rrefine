#' Apply operations to OpenRefine project
#'
#' This function allows users to pass arbitrary operations to an OpenRefine project via an API query to `/command/core/apply-operations`. The operations to perform must be formatted as valid `JSON` and passed to this function as a `list` object. For more on
#'
#' @param project.name Name of project
#' @param project.id Unique identifier for project
#' @param operations List of operations to perform
#' @param verbose Logical specifying whether or not query result should be printed; default is `FALSE`
#' @param ... Additional parameters to be inherited by \code{\link{refine_path}}; allows users to specify `host` and `port` arguments if the OpenRefine instance is running at a location other than `http://127.0.0.1:3333`
#'
#' @md
#' @references \url{https://docs.openrefine.org/technical-reference/openrefine-api#apply-operations}
#' @return Operates as a side-effect passing operations to the OpenRefine instance. However, if `verbose=TRUE` then the function will return an object of the class "response".
#' @export
#'
#' @examples
#' \dontrun{
#'fp <- system.file("extdata", "lateformeeting.csv", package = "rrefine")
#'refine_upload(fp, project.name = "lfm")
#'
#'ops <-
#'    list(
#'        op = "core/text-transform",
#'        description = "Force column to upper case",
#'        engineConfig = list(mode = "row-based", facets = list()),
#'        columnName = "was i on time for work",
#'        expression = "value.toUppercase()",
#'        onError = "set-to-blank")
#'
#'refine_operations(project.name = "lfm", operations = list(ops), verbose = TRUE)
#' }
#'
refine_operations <- function(project.name = NULL, project.id = NULL, verbose = FALSE, operations, ...) {

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

    res <-
        httr::POST(query,
                   body = list(operations = operations),
                   encode = "form",
                   httr::content_type('application/x-www-form-urlencoded'))

    if(verbose) {
        return(res)
    }


}


#' Remove column from OpenRefine project
#'
#' This function will remove a column from an existing OpenRefine project via an API query to `/command/core/apply-operations` and the `core/column-removal` operation.
#'
#' @param column Name of the column to be removed
#' @param project.name Name of project
#' @param project.id Unique identifier for project
#' @param verbose Logical specifying whether or not query result should be printed; default is `FALSE`
#' @param ... Additional parameters to be inherited by \code{\link{refine_path}}; allows users to specify `host` and `port` arguments if the OpenRefine instance is running at a location other than `http://127.0.0.1:3333`
#'
#' @md
#' @return Operates as a side-effect passing operations to the OpenRefine instance. However, if `verbose=TRUE` then the function will return an object of the class "response".
#'
#' @examples
#' \dontrun{
#'fp <- system.file("extdata", "lateformeeting.csv", package = "rrefine")
#'refine_upload(fp, project.name = "lfm")
#'
#'refine_remove_column(column = "theDate", project.name = "lfm")
#' }
#'
#' @export
#'
refine_remove_column <- function(column, project.name = NULL, project.id = NULL, verbose = FALSE, ...) {

    res <-
        refine_operations(project.name = project.name,
                          project.id = project.id,
                          operations = list(list(op = "core/column-removal",
                                                 columnName = column)),
                      ...)
    if(verbose) {
        return(res)
    }
}

#' Add column to OpenRefine project
#'
#' This function will add a column to an existing OpenRefine project via an API query to `/command/core/apply-operations` and the `core/column-addition` operation. The value for the new column can be specified in this function either based on value of an existing column. The value can be defined using an expression written in [General Refine Expression Language (GREL)](https://docs.openrefine.org/manual/grel) syntax.
#'
#' @param new_column Name of the new column
#' @param new_column_index Index at which the new column should be placed in the project; default is `0` to position the new column as the first column in the project
#' @param base_column Name of the column on which the value will be based; default is `NULL`, which means that the value will not be based off of a value in an existing column
#' @param value Definition of the value for the new column; can accept a GREL expression
#' @param on_error Behavior if there is an error on new column creation; must be one of `"set-to-blank"`, `"keep-original"`, or `"store-error"`; default is `"set-to-blank"`
#' @param description Text describing the operation performed
#' @param project.name Name of project
#' @param project.id Unique identifier for project
#' @param verbose Logical specifying whether or not query result should be printed; default is `FALSE`
#' @param ... Additional parameters to be inherited by \code{\link{refine_path}}; allows users to specify `host` and `port` arguments if the OpenRefine instance is running at a location other than `http://127.0.0.1:3333`
#'
#' @md
#' @return Operates as a side-effect passing operations to the OpenRefine instance. However, if `verbose=TRUE` then the function will return an object of the class "response".
#'
#' @examples
#' \dontrun{
#'fp <- system.file("extdata", "lateformeeting.csv", package = "rrefine")
#'refine_upload(fp, project.name = "lfm")
#'
#'refine_add_column(new_column = "date_type", new_column_index = 0, value = "grel:value.type()", base_column = "theDate", description = "Adding new column based on theDate", project.name = "lfm")
#'refine_add_column(new_column = "example_value", new_column_index = 0, value = "1", description = "Adding new column with all rows populated with arbitrary value", project.name = "lfm")
#' }
#' @export
#'
refine_add_column <- function(new_column, new_column_index = 0, base_column = NULL, value, on_error = "set-to-blank", description = NULL, project.name = NULL, project.id = NULL, verbose = FALSE, ...) {

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
