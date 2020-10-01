#' upload a csv file to OpenRefine
#'
#' @param file Name of csv file to be uploaded
#' @param project.name optional parameter to specify name of the project to be created upon upload, default is NULL and project will be named 'Untitled' in OpenRefine
#' @param open.browser logical for whether or not the browser should open on successful upload
#' @export
#' @examples
#' \dontrun{
#' write.csv(x = mtcars, file = "mtcars.csv")
#' refine_upload(file = "mtcars.csv", project.name = "mtcars_clean_up")
#' }
#'

refine_upload <- function(file, project.name = NULL , open.browser = FALSE) {

    refine_check()

    # define upload query
    query <- refine_query("create-project-from-upload", use_token = TRUE)
    # post project to refine
    httr::POST(query,
               body = list(
        "project-file" = httr::upload_file(file),
        "project-name" = project.name)
        )

    # view open refine in browser
    if (open.browser)
        utils::browseURL(refine_path()) else
            message("Success!")
}
