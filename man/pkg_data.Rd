% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/trait_pkg_data.R
\name{pkg_data}
\alias{pkg_data}
\alias{pkg_data_derive}
\alias{pkg_data_get_class}
\alias{pkg_data_get_description}
\alias{pkg_data_get_tags}
\alias{pkg_data_get_permissions}
\alias{pkg_data_get_suggests}
\alias{pkg_data_is_metric}
\alias{impl_data}
\alias{impl_data_meta}
\alias{impl_data_derive}
\alias{impl_metric}
\title{Package Data Trait}
\usage{
pkg_data_derive(field, pkg, resource, ...)

pkg_data_get_class(field, ...)

pkg_data_get_description(field, ...)

pkg_data_get_tags(field, ...)

pkg_data_get_permissions(field, ...)

pkg_data_get_suggests(field, ...)

pkg_data_is_metric(field, ...)

impl_data(name, fn, for_resource = resource, ..., metric = FALSE)

impl_data_meta(
  name,
  class = class_any,
  description = "",
  tags = class_tags(c()),
  permissions = class_permissions(c()),
  suggests = character(0L)
)

impl_data_derive(name, fn, resource)

impl_metric(name, class = pkg_data_get_class(name))
}
\description{
A trait is a collection of methods. Implemented a new piece of package data
requires that all of the following methods are implemented or have a provided
default implementation.
}
\details{
Although it's possibly to implement all of these methods one by one, it will
be easier to use \code{\link[=impl_data]{impl_data()}}, which takes only the expected data and
uses it to implemented each method.
}
\section{Functions}{
\itemize{
\item \code{pkg_data_derive()}: Derive a \code{\link{pkg}} data field, giving a function by which a piece of package
data is calculated. This function is not called directly, it used by the
indexing functions implemented for \code{\link{pkg}} to populate new data fields.
Default implementations accept \code{field} as a \code{character}, automatically
dispatching on the field as a class object, and accept a missing
\code{resource}, instead iterating through \code{pkg} resources by priority.

\item \code{pkg_data_get_class()}: Retrieve the class of the data field. When implemented using \code{\link[=impl_data]{impl_data()}},
the result of calling \code{\link[=pkg_data_derive]{pkg_data_derive()}} is automatically converted into
this class, raising errors if conversion fails. The default implementation
returns \code{\link[S7:class_any]{S7::class_any}}, though it is recommended that a more precise
class should be specified.

\item \code{pkg_data_get_description()}: Retrieve a description of the data field. Descriptions should be roughly one
sentence and for metrics, provide necessary information for interpretting the
result. The default implmentation provides no description.

\item \code{pkg_data_get_tags()}: Retrieve a \code{\link[=tags]{tags()}} object describing tags associated with the data field.
The default implementation lists no tags.

\item \code{pkg_data_get_permissions()}: Retrieve a \code{\link[=permissions]{permissions()}} object describing necessary permissions required
to compute the data. The default implementation lists no required
permissions.

\item \code{pkg_data_get_suggests()}: Retrieve a vector of any \code{Suggests} dependencies required for deriving the
data. The default implementation returns no dependencies.

\item \code{pkg_data_is_metric()}: Retrieve a \code{logical} flag, indicating whether the data field is a \code{metric}.
When implemented using \code{\link[=impl_data]{impl_data()}}, defining a field of data as a metric
also enforces that its return type is atomic. The default implementation
always returns \code{FALSE}.

\item \code{impl_data()}: Helper for implementing all the necessary methods for package data.
Internally this is a wrapper for \verb{[impl_data_meta()]} (associate metadata
with the data field), \verb{[impl_data_derive()]} (associate a derivation
function for a combination of data field \emph{and} package resource) and
\verb{[impl_metric()]} (declare a piece of data to be a metric).

\item \code{impl_data_meta()}: Associate metadata with the data field

\item \code{impl_data_derive()}: Register a derivation function for a data field and package resource.

\item \code{impl_metric()}: Declare a data field to be a metric, enforcing that the derivation return
type is atomic.

}}
