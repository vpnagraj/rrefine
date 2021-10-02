# rrefine 1.1.2

Minor release to incorporate new features. 

## New Features

- When using `refine_export` the user can now specify "col_types" for tabular format returned. Thanks to @joelnitta for the contribution!

# rrefine 1.1.1

The only update in this release is the removal of one of the package dependencies (`rlist`), which has been scheduled to be archived per the CRAN team. This change is required for continued distribution of `rrefine` via CRAN. Functions from `rlist` were only used in an unexported `rrefine` helper, and there are no anticipated user-facing changes in this release.

# rrefine 1.1.0

This release includes a number of new features, more robust checks and internal logic, and many improvements to package documentation. Most significantly, this version introduces support for the Cross-Site Request Forgery (CSRF) token in OpenRefine API requests, which is required in certain API calls as of OpenRefine v3.3. This feature is now included in `rrefine` but operates internally and should be invisible to users. For more information the OpenRefine CSRF protection see: https://github.com/OpenRefine/OpenRefine/wiki/Changes-for-3.3#csrf-protection-changes

## New Features

- The `refine_metadata()` function is now exported and user-facing.
- Users can now specify other hosts and/or ports for a running OpenRefine instance (default is still `http://127.0.0.1:3333`)
- The `refine_upload()` function now checks file format based on extension, and allows both .csv and .tsv files to be uploaded.
- Successful calls to `refine_upload(..., open.browser=TRUE)` will now redirect the user to the newly created project in the OpenRefine instance.
- When exporting project data, users can now specify 'tsv' or 'csv' export format. Both will return a `tibble` with the data in R.
- Messaging to the user is now more accurate and informative; messages include the given project id/name for the operation where appropriate.
- The `refine_upload()` and `refine_delete()` functions now confirm success of operations by comparing metadata before/after POST requests.
- The API to construct queries to OpenRefine is now standardized in the `refine_query()` internal helper function.
- More robust documentation (inline and user-facing), including descriptions of return values and references to OpenRefine API endpoints used.
- The `refine_id()` helper function now validates "project.id" against list of project ids in the running instance.
- Added `news.md` to track release notes!

## Bug Fixes

- Calls to `refine_delete()` and `refine_upload()` now generate a CSFR token internally.

## Tests

Tested with OpenRefine 3.2, 3.3, and 3.4.1 running on Linux and Mac OSX.

---

# rrefine 1.0

- Initial release!

---

> **NOTE** The `rrefine` package was released to CRAN under version 1.0. However, the `DESCRIPTION` file for that release noted the version as 0.1. All releases from v1.1.0 onwards will maintain consistency between the version in the `DESCRIPTION` and the version number on the CRAN release.
