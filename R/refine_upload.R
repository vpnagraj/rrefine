#' Upload a file to OpenRefine
#'
#' This function attempts to upload contents of a file and create a new project in OpenRefine. Users can optionally navigate directly to the running instance to interact with the project. The function wraps the OpenRefine API `/command/core/create-project-from-upload` query.
#'
#' @param file Path to file to upload
#' @param project.name Optional parameter to specify name of the project to be created upon upload; default is `NULL` and project will be named 'Untitled' in OpenRefine
#' @param open.browser Boolean for whether or not the browser should open on successful upload; default is `FALSE`
#'
#' @return Operates as a side-effect, either opening a browser and pointing to the OpenRefine instance (if `open.browser=TRUE`) or issuing a message.
#' @references \url{https://github.com/OpenRefine/OpenRefine/wiki/OpenRefine-API#create-project}
#' @export
#' @md
#' @examples
#' \dontrun{
#' write.csv(x = mtcars, file = "mtcars.csv")
#' refine_upload(file = "mtcars.csv", project.name = "mtcars_clean_up")
#' }
#'

refine_upload <- function(file, project.name = NULL , open.browser = FALSE) {

    ## check that OpenRefine is running
    refine_check()

    ## define upload query
    query <- refine_query("create-project-from-upload", use_token = TRUE)
    ## post project to refine
    httr::POST(query,
               body = list(
        "project-file" = httr::upload_file(file),
        "project-name" = project.name)
        )

    ## open browser
    if (open.browser) {
        utils::browseURL(refine_path())
    } else {
        message("Attempting ")
    }
}
