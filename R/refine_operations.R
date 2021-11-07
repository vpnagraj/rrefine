#' Apply operations to OpenRefine project
#'
#' This function allows users to pass arbitrary operations to an OpenRefine project via an API query to `/command/core/apply-operations`. The operations to perform must be formatted as valid `JSON` and passed to this function as a `list` object.
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

    refine_operations(project.name = project.name,
                      project.id = project.id,
                      operations = list(list(op = "core/column-removal",
                                             columnName = column)),
                      verbose = verbose,
                      ...)
}

#' Add column to OpenRefine project
#'
#' This function will add a column to an existing OpenRefine project via an API query to `/command/core/apply-operations` and the `core/column-addition` operation. The value for the new column can be specified in this function either based on value of an existing column. The value can be defined using an expression written in [General Refine Expression Language (GREL)](https://docs.openrefine.org/manual/grel) syntax.
#'
#' @param new_column Name of the new column
#' @param new_column_index Index at which the new column should be placed in the project; default is `0` to position the new column as the first column in the project
#' @param base_column Name of the column on which the value will be based; default is `NULL`, which means that the value will not be based off of a value in an existing column
#' @param value Definition of the value for the new column; can accept a GREL expression
#' @param mode Mode of operation; must be one of `"row-based"` or `"record-based"`; default is `"row-based`
#' @param on_error Behavior if there is an error on new column creation; must be one of `"set-to-blank"`, `"keep-original"`, or `"store-error"`; default is `"set-to-blank"`
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
#'refine_add_column(new_column = "date_type",
#'                  value = "grel:value.type()",
#'                  base_column = "theDate",
#'                  project.name = "lfm")
#'
#'refine_add_column(new_column = "example_value",
#'                  new_column_index = 0,
#'                  value = "1",
#'                  project.name = "lfm")
#' }
#' @export
#'
refine_add_column <- function(new_column, new_column_index = 0, base_column = NULL, value, mode = "row-based", on_error = "set-to-blank", project.name = NULL, project.id = NULL, verbose = FALSE, ...) {

    ops <-
        list(
            op = "core/column-addition",
            engineConfig = list(mode = mode, facets = list()),
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
                      verbose = verbose,
                      ...)
}

#' Rename a column in OpenRefine project
#'
#' This function allows users to rename an existing column in an OpenRefine project via an API query to `/command/core/apply-operations` and the `core/column-rename` operation.
#'
#' @param original_name Original name for the column
#' @param new_name New name for the column
#' @param project.name Name of project
#' @param project.id Unique identifier for project
#' @param verbose Logical specifying whether or not query result should be printed; default is `FALSE`
#' @param ... Additional parameters to be inherited by \code{\link{refine_path}}; allows users to specify `host` and `port` arguments if the OpenRefine instance is running at a location other than `http://127.0.0.1:3333`
#'
#' @return Operates as a side-effect passing operations to the OpenRefine instance. However, if `verbose=TRUE` then the function will return an object of the class "response".
#'
#' @md
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#'fp <- system.file("extdata", "lateformeeting.csv", package = "rrefine")
#'refine_upload(fp, project.name = "lfm")
#'refine_rename_column("what day whas it", "what_day_was_it", project.name = "lfm")
#' }
#'
#'
refine_rename_column <- function(original_name, new_name, project.name = NULL, project.id = NULL, verbose = FALSE, ...) {

    ops <-
        list(
            op = "core/column-rename",
            newColumnName = new_name,
            oldColumnName = original_name)

    refine_operations(project.name = project.name,
                      project.id = project.id,
                      operations = list(ops),
                      verbose = verbose,
                      ...)
}

#' Move a column in OpenRefine project
#'
#' This function allows users to move an existing column in an OpenRefine project via an API query to `/command/core/apply-operations` and the `core/column-move` operation.
#'
#' @param column Name of the column to be removed
#' @param index Index to which the column should be placed in the project; default is `0` to position the new column as the first column in the project
#' @param project.name Name of project
#' @param project.id Unique identifier for project
#' @param verbose Logical specifying whether or not query result should be printed; default is `FALSE`
#' @param ... Additional parameters to be inherited by \code{\link{refine_path}}; allows users to specify `host` and `port` arguments if the OpenRefine instance is running at a location other than `http://127.0.0.1:3333`
#'
#' @return Operates as a side-effect passing operations to the OpenRefine instance. However, if `verbose=TRUE` then the function will return an object of the class "response".
#'
#' @md
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#'fp <- system.file("extdata", "lateformeeting.csv", package = "rrefine")
#'refine_upload(fp, project.name = "lfm")
#'refine_move_column("sleephours", index = 0, project.name = "lfm")
#' }
#'
#'
refine_move_column <- function(column, index = 0, project.name = NULL, project.id = NULL, verbose = FALSE, ...) {

    ops <-
        list(
            op = "core/column-move",
            columnName = column,
            index = index)

    refine_operations(project.name = project.name,
                      project.id = project.id,
                      operations = list(ops),
                      verbose = verbose,
                      ...)
}

#' Text transformation for OpenRefine project
#'
#' @name transform
#'
#' @description
#'
#' The text transform functions allow users to pass arbitrary text transformations to a column in an existing OpenRefine project via an API query to `/command/core/apply-operations` and the `core/text-transform` operation. Besides the generic `refine_transform()`, the package includes a series of transform functions that apply commonly used text operations. For more information on these functions see 'Details'.
#'
#' @param column_name Name of the column on which text transformation should be performed
#' @param expression Expression defining the text transformation to be performed
#' @param mode Mode of operation; must be one of `"row-based"` or `"record-based"`; default is `"row-based`
#' @param on_error Behavior if there is an error on new column creation; must be one of `"set-to-blank"`, `"keep-original"`, or `"store-error"`; default is `"set-to-blank"`
#' @param project.name Name of project
#' @param project.id Unique identifier for project
#' @param verbose Logical specifying whether or not query result should be printed; default is `FALSE`
#' @param ... Additional parameters to be inherited by \code{\link{refine_path}}; allows users to specify `host` and `port` arguments if the OpenRefine instance is running at a location other than `http://127.0.0.1:3333`
#'
#' @details
#' The `refine_transform()` function allows the user to pass arbitrary text transformations to a given column in an OpenRefine project. The package includes a set of functions that wrap `refine_transform()` to execute common transformations:
#'
#' - `refine_to_lower()`: Coerce text to lowercase
#' - `refine_to_upper()`: Coerce text to uppercase
#' - `refine_to_title()`: Coerce text to title case
#' - `refine_to_null()`: Set values to `NULL`
#' - `refine_to_empty()`: Set text values to empty string (`""`)
#' - `refine_to_text()`: Coerce value to string
#' - `refine_to_number()`: Coerce value to numeric
#' - `refine_to_date()`: Coerce value to date
#' - `refine_trim_whitespace()`: Remove leading and trailing whitespaces
#' - `refine_collapse_whitespace()`: Collapse consecutive whitespaces to single whitespace
#' - `refine_unescape_html()`: Unescape HTML in string
#'
#' @return Operates as a side-effect passing operations to the OpenRefine instance. However, if `verbose=TRUE` then the function will return an object of the class "response".
#'
#' @md
#'
#' @export
#'
#' @examples
#' \dontrun{
#'fp <- system.file("extdata", "lateformeeting.csv", package = "rrefine")
#'refine_upload(fp, project.name = "lfm")
#'
#'refine_add_column(new_column = "dotw",
#'                  base_column = "what day whas it",
#'                  value = "grel:value",
#'                  project.name = "lfm")
#'
#'refine_export("lfm")$dotw
#'refine_to_lower("dotw", project.name = "lfm")
#'refine_export("lfm")$dotw
#'refine_to_upper("dotw", project.name = "lfm")
#'refine_export("lfm")$dotw
#'refine_to_title("dotw", project.name = "lfm")
#'refine_export("lfm")$dotw
#'refine_to_null("dotw", project.name = "lfm")
#'refine_export("lfm")$dotw
#'refine_remove_column("dotw", project.name = "lfm")
#'
#'refine_add_column(new_column = "date",
#'                  base_column = "theDate",
#'                  value = "grel:value",
#'                  project.name = "lfm")
#'
#'refine_export("lfm")$date
#'refine_to_date("date", project.name = "lfm")
#'refine_export("lfm")$date
#'refine_remove_column("date", project.name = "lfm")
#'
#' }
#'
refine_transform <- function(column_name, expression, mode = "row-based", on_error = "set-to-blank", project.name = NULL, project.id = NULL, verbose = FALSE, ...) {

    ops <-
        list(
            op = "core/text-transform",
            engineConfig = list(mode = mode, facets = list()),
            columnName = column_name,
            expression = expression,
            onError = on_error)

    refine_operations(project.name = project.name,
                      project.id = project.id,
                      operations = list(ops),
                      verbose = verbose,
                      ...)
}

#' @export
#' @rdname transform
refine_to_lower <- function(column_name, mode = "row-based", on_error = "set-to-blank", project.name = NULL, project.id = NULL, verbose = FALSE, ...) {

    refine_transform(column_name = column_name,
                     expression = "value.toLowercase()",
                     mode = mode,
                     on_error = on_error,
                     project.name = project.name,
                     project.id = project.id,
                     verbose = verbose,
                     ...)

}

#' @export
#' @rdname transform
refine_to_upper <- function(column_name, mode = "row-based", on_error = "set-to-blank", project.name = NULL, project.id = NULL, verbose = FALSE, ...) {

    refine_transform(column_name = column_name,
                     expression = "value.toUppercase()",
                     mode = mode,
                     on_error = on_error,
                     project.name = project.name,
                     project.id = project.id,
                     verbose = verbose,
                     ...)

}

#' @export
#' @rdname transform
refine_to_title <- function(column_name, mode = "row-based", on_error = "set-to-blank", project.name = NULL, project.id = NULL, verbose = FALSE, ...) {

    refine_transform(column_name = column_name,
                     expression = "value.toTitlecase()",
                     mode = mode,
                     on_error = on_error,
                     project.name = project.name,
                     project.id = project.id,
                     verbose = verbose,
                     ...)

}

#' @export
#' @rdname transform
refine_to_null <- function(column_name, mode = "row-based", on_error = "set-to-blank", project.name = NULL, project.id = NULL, verbose = FALSE, ...) {

    refine_transform(column_name = column_name,
                     expression = "null",
                     mode = mode,
                     on_error = on_error,
                     project.name = project.name,
                     project.id = project.id,
                     verbose = verbose,
                     ...)

}

#' @export
#' @rdname transform
refine_to_empty <- function(column_name, mode = "row-based", on_error = "set-to-blank", project.name = NULL, project.id = NULL, verbose = FALSE, ...) {

    refine_transform(column_name = column_name,
                     expression = "\"\"",
                     mode = mode,
                     on_error = on_error,
                     project.name = project.name,
                     project.id = project.id,
                     verbose = verbose,
                     ...)

}

#' @export
#' @rdname transform
refine_to_text <- function(column_name, mode = "row-based", on_error = "set-to-blank", project.name = NULL, project.id = NULL, verbose = FALSE, ...) {

    refine_transform(column_name = column_name,
                     expression = "value.toString()",
                     mode = mode,
                     on_error = on_error,
                     project.name = project.name,
                     project.id = project.id,
                     verbose = verbose,
                     ...)

}

#' @export
#' @rdname transform
refine_to_number <- function(column_name, mode = "row-based", on_error = "set-to-blank", project.name = NULL, project.id = NULL, verbose = FALSE, ...) {

    refine_transform(column_name = column_name,
                     expression = "value.toNumber()",
                     mode = mode,
                     on_error = on_error,
                     project.name = project.name,
                     project.id = project.id,
                     verbose = verbose,
                     ...)

}

#' @export
#' @rdname transform
refine_to_date <- function(column_name, mode = "row-based", on_error = "set-to-blank", project.name = NULL, project.id = NULL, verbose = FALSE, ...) {

    refine_transform(column_name = column_name,
                     expression = "value.toDate()",
                     mode = mode,
                     on_error = on_error,
                     project.name = project.name,
                     project.id = project.id,
                     verbose = verbose,
                     ...)

}

#' @export
#' @rdname transform
refine_trim_whitespace <- function(column_name, mode = "row-based", on_error = "set-to-blank", project.name = NULL, project.id = NULL, verbose = FALSE, ...) {

    refine_transform(column_name = column_name,
                     expression = "value.trim()",
                     mode = mode,
                     on_error = on_error,
                     project.name = project.name,
                     project.id = project.id,
                     verbose = verbose,
                     ...)

}

#' @export
#' @rdname transform
refine_collapse_whitespace <- function(column_name, mode = "row-based", on_error = "set-to-blank", project.name = NULL, project.id = NULL, verbose = FALSE, ...) {

    refine_transform(column_name = column_name,
                     expression = "value.replace(/\\s+/,' ')",
                     mode = mode,
                     on_error = on_error,
                     project.name = project.name,
                     project.id = project.id,
                     verbose = verbose,
                     ...)

}

#' @export
#' @rdname transform
refine_unescape_html <- function(column_name, mode = "row-based", on_error = "set-to-blank", project.name = NULL, project.id = NULL, verbose = FALSE, ...) {

    refine_transform(column_name = column_name,
                     expression = "value.unescape('html')",
                     mode = mode,
                     on_error = on_error,
                     project.name = project.name,
                     project.id = project.id,
                     verbose = verbose,
                     ...)

}
