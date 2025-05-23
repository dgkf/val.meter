#' @include class_permissions.R
#' @include class_tags.R
metric <- new_class(
  "metric",
  properties = list(
    metric = class_logical,
    description = class_character,
    tags = tags,
    type = new_property(class_any, validator = function(value) {
      res <- tryCatch(S7::as_class(value), error = function(e) e)
      if (inherits(res, "error")) res$message
    }),
    suggests = class_character,
    scopes = permissions
  )
)

method(format, metric) <-
  function(
    x,
    ...,
    permissions = opt("permissions"),
    tags = opt("tags")
  ) {
    type <- if (S7::S7_inherits(x@type)) {  # nolint: object_usage_linter.
      x@type@name
    } else {
      S7:::class_desc(x@type)
    }

    is_installed <- vlapply(x@suggests, requireNamespace, quietly = TRUE)
    any_tags <- length(x@tags) + length(x@scopes) + length(x@suggests) > 0

    c(
      # data type
      fmt(style_dim("{type}")),

      if (any_tags) paste(collapse = " ", c(
        # tags
        vcapply(x@tags, function(tag) {
          color <- if (tag %in% tags) "blue" else "red"
          fmt(cli_tag(tag, scope = "", color = color))
        }),

        # permissions
        vcapply(x@scopes, function(scope) {
          color <- if (scope %in% permissions) "green" else "red"
          fmt(cli_tag(scope, scope = "req", color = color))
        }),

        # suggests dependencies
        vcapply(seq_along(x@suggests), function(i) {
          color <- if (is_installed[[i]]) "green" else "red"
          fmt(cli_tag(scope = "dep", x@suggests[[i]], color = color))
        })
      )),

      # description
      if (nchar(x@description) > 0L) fmt(style_italic("{x@description}"))
    )
  }

method(print, metric) <-
  function(
    x,
    permissions = opt("permissions"),
    tags = opt("tags"),
    ...
  ) {
    cat(paste(collapse = "\n", format(x, ...)), "\n")

    if (!all(x@scopes %in% permissions) || !all(x@tags %in% tags)) {
      cli_inform(
        paste0(
          "metric(s) will be disabled due to insufficient permissions or ",
          "restricted tags. See {.code ?{ packageName() }::options()} for ",
          "details about global policies."
        ),
        class = cnd_type("options", cnd = "message")
      )
    }

    invisible(x)
  }

#' @export
format.val_meter_error <- function(x, ...) {
  NextMethod(
    backtrace = FALSE,
    simplify = "branch",
    drop = TRUE,
    prefix = FALSE,
    ...
  )
}

#' @export
print.val_meter_error <- function(x, ...) {
  cat(format(x, ...), "\n")
}

method(convert, list(class_character, metric)) <-
  function(from, to) {
    metric(
      metric = pkg_data_is_metric(from),
      description = pkg_data_get_description(from),
      tags = pkg_data_get_tags(from),
      type = pkg_data_get_class(from),
      suggests = pkg_data_get_suggests(from),
      scopes = pkg_data_get_permissions(from)
    )
  }

metrics_list <- new_class("metrics_list", parent = class_list)

method(print, metrics_list) <- function(x, ...) {
  msgs <- list()

  to_print <- x
  class(to_print) <- NULL
  attributes(to_print) <- NULL
  names(to_print) <- names(x)

  res <- withCallingHandlers(
    print(to_print),
    message = function(m) {
      if (inherits(m, cnd_type(cnd = "message"))) {
        msgs <<- append(msgs, list(m))
        invokeRestart("muffleMessage")
      }
    }
  )

  if (length(msgs) > 0L) {
    cli_alert_info("Some metrics will not be evaluated")
  }

  for (msg in unique(msgs)) {
    cli_text(style_dim(msg$message))
  }

  invisible(res)
}

#' @export
metrics <- function(all = FALSE) {
  fields <- get_data_derive_field_names()
  names(fields) <- fields
  fields <- lapply(fields, convert, to = metric)
  is_metric <- vlapply(fields, S7::prop, "metric")
  if (!all) fields <- fields[is_metric]
  metrics_list(fields)
}
