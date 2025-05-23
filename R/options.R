#' @eval options::as_roxygen_docs()
NULL

#' Options As Parameters
#' @eval options::as_params()
#' @name options_params
NULL

#' @include utils_cli.R
define_options(
  fmt("Set the default {packageName()} package search policy."),
  policy = pkg_resource_policy(),

  fmt("
    Set the default {packageName()} data permissions policy. Permissions
    specify what capabilities are permitted when deriving package data. For more
    details, see [`permissions()`].
  "),
  permissions = permissions(FALSE),

  fmt("
    Set the default {packageName()} tags policy. Tags characterize the types
    of information various metrics contain. For more details, see
    [`tags()`].
  "),
  tags = tags(TRUE)
)
