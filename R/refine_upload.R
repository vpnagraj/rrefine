#' helper function to configure and call path to open refine
#'
#' @param file file name to be uploaded
#' @param project_name name of the project to be created upon upload, default is NULL and will project will be named 'Untitled' in open refine
#' @param open.browser boolean for whether or not you want to open browser
#' @export
#' @examples
#' \dontrun{
#' write.csv(x = mtcars, file = "mtcars.csv")
#' refine_upload(file = "mtcars.csv", project_name = "mtcars_clean_up")
#' }
#'

refine_upload <- function(file, project_name = NULL , open.browser = FALSE) {

    # define upload query based on configurations in refine_path()
    refpath <- paste0(refine_path(), "/", "command/core/create-project-from-upload")

    # post project to refine
    httr::POST(refpath,
               body = list(
        "project-file" = httr::upload_file(file),
        "project-name" = project_name)
        )

    # view open refine in browser
    if (open.browser)
        browseURL(refine_path()) else
            message("Success!")
}
