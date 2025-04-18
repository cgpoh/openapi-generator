#' Create a new Pet
#'
#' @description
#' A pet for sale in the pet store
#'
#' @docType class
#' @title Pet
#' @description Pet Class
#' @format An \code{R6Class} generator object
#' @field id  integer [optional]
#' @field category  \link{Category} [optional]
#' @field name  character
#' @field photoUrls  list(character)
#' @field tags  list(\link{Tag}) [optional]
#' @field status pet status in the store character [optional]
#' @importFrom R6 R6Class
#' @importFrom jsonlite fromJSON toJSON
#' @export
Pet <- R6::R6Class(
  "Pet",
  public = list(
    `id` = NULL,
    `category` = NULL,
    `name` = NULL,
    `photoUrls` = NULL,
    `tags` = NULL,
    `status` = NULL,

    #' @description
    #' Initialize a new Pet class.
    #'
    #' @param name name
    #' @param photoUrls photoUrls
    #' @param id id
    #' @param category category
    #' @param tags tags
    #' @param status pet status in the store
    #' @param ... Other optional arguments.
    initialize = function(`name`, `photoUrls`, `id` = NULL, `category` = NULL, `tags` = NULL, `status` = NULL, ...) {
      if (!missing(`name`)) {
        if (!(is.character(`name`) && length(`name`) == 1)) {
          stop(paste("Error! Invalid data for `name`. Must be a string:", `name`))
        }
        self$`name` <- `name`
      }
      if (!missing(`photoUrls`)) {
        stopifnot(is.vector(`photoUrls`), length(`photoUrls`) != 0)
        sapply(`photoUrls`, function(x) stopifnot(is.character(x)))
        self$`photoUrls` <- `photoUrls`
      }
      if (!is.null(`id`)) {
        if (!(is.numeric(`id`) && length(`id`) == 1)) {
          stop(paste("Error! Invalid data for `id`. Must be an integer:", `id`))
        }
        self$`id` <- `id`
      }
      if (!is.null(`category`)) {
        stopifnot(R6::is.R6(`category`))
        self$`category` <- `category`
      }
      if (!is.null(`tags`)) {
        stopifnot(is.vector(`tags`), length(`tags`) != 0)
        sapply(`tags`, function(x) stopifnot(R6::is.R6(x)))
        self$`tags` <- `tags`
      }
      if (!is.null(`status`)) {
        if (!(`status` %in% c("available", "pending", "sold"))) {
          stop(paste("Error! \"", `status`, "\" cannot be assigned to `status`. Must be \"available\", \"pending\", \"sold\".", sep = ""))
        }
        if (!(is.character(`status`) && length(`status`) == 1)) {
          stop(paste("Error! Invalid data for `status`. Must be a string:", `status`))
        }
        self$`status` <- `status`
      }
    },

    #' @description
    #' Convert to an R object. This method is deprecated. Use `toSimpleType()` instead.
    toJSON = function() {
      .Deprecated(new = "toSimpleType", msg = "Use the '$toSimpleType()' method instead since that is more clearly named. Use '$toJSONString()' to get a JSON string")
      return(self$toSimpleType())
    },

    #' @description
    #' Convert to a List
    #'
    #' Convert the R6 object to a list to work more easily with other tooling.
    #'
    #' @return Pet as a base R list.
    #' @examples
    #' # convert array of Pet (x) to a data frame
    #' \dontrun{
    #' library(purrr)
    #' library(tibble)
    #' df <- x |> map(\(y)y$toList()) |> map(as_tibble) |> list_rbind()
    #' df
    #' }
    toList = function() {
      return(self$toSimpleType())
    },

    #' @description
    #' Convert Pet to a base R type
    #'
    #' @return A base R type, e.g. a list or numeric/character array.
    toSimpleType = function() {
      PetObject <- list()
      if (!is.null(self$`id`)) {
        PetObject[["id"]] <-
          self$`id`
      }
      if (!is.null(self$`category`)) {
        PetObject[["category"]] <-
          self$`category`$toSimpleType()
      }
      if (!is.null(self$`name`)) {
        PetObject[["name"]] <-
          self$`name`
      }
      if (!is.null(self$`photoUrls`)) {
        PetObject[["photoUrls"]] <-
          self$`photoUrls`
      }
      if (!is.null(self$`tags`)) {
        PetObject[["tags"]] <-
          lapply(self$`tags`, function(x) x$toSimpleType())
      }
      if (!is.null(self$`status`)) {
        PetObject[["status"]] <-
          self$`status`
      }
      return(PetObject)
    },

    #' @description
    #' Deserialize JSON string into an instance of Pet
    #'
    #' @param input_json the JSON input
    #' @return the instance of Pet
    fromJSON = function(input_json) {
      this_object <- jsonlite::fromJSON(input_json)
      if (!is.null(this_object$`id`)) {
        self$`id` <- this_object$`id`
      }
      if (!is.null(this_object$`category`)) {
        `category_object` <- Category$new()
        `category_object`$fromJSON(jsonlite::toJSON(this_object$`category`, auto_unbox = TRUE, digits = NA))
        self$`category` <- `category_object`
      }
      if (!is.null(this_object$`name`)) {
        self$`name` <- this_object$`name`
      }
      if (!is.null(this_object$`photoUrls`)) {
        self$`photoUrls` <- ApiClient$new()$deserializeObj(this_object$`photoUrls`, "array[character]", loadNamespace("petstore"))
      }
      if (!is.null(this_object$`tags`)) {
        self$`tags` <- ApiClient$new()$deserializeObj(this_object$`tags`, "array[Tag]", loadNamespace("petstore"))
      }
      if (!is.null(this_object$`status`)) {
        if (!is.null(this_object$`status`) && !(this_object$`status` %in% c("available", "pending", "sold"))) {
          stop(paste("Error! \"", this_object$`status`, "\" cannot be assigned to `status`. Must be \"available\", \"pending\", \"sold\".", sep = ""))
        }
        self$`status` <- this_object$`status`
      }
      self
    },

    #' @description
    #' To JSON String
    #' 
    #' @param ... Parameters passed to `jsonlite::toJSON`
    #' @return Pet in JSON format
    toJSONString = function(...) {
      simple <- self$toSimpleType()
      json <- jsonlite::toJSON(simple, auto_unbox = TRUE, digits = NA, ...)
      return(as.character(jsonlite::minify(json)))
    },

    #' @description
    #' Deserialize JSON string into an instance of Pet
    #'
    #' @param input_json the JSON input
    #' @return the instance of Pet
    fromJSONString = function(input_json) {
      this_object <- jsonlite::fromJSON(input_json)
      self$`id` <- this_object$`id`
      self$`category` <- Category$new()$fromJSON(jsonlite::toJSON(this_object$`category`, auto_unbox = TRUE, digits = NA))
      self$`name` <- this_object$`name`
      self$`photoUrls` <- ApiClient$new()$deserializeObj(this_object$`photoUrls`, "array[character]", loadNamespace("petstore"))
      self$`tags` <- ApiClient$new()$deserializeObj(this_object$`tags`, "array[Tag]", loadNamespace("petstore"))
      if (!is.null(this_object$`status`) && !(this_object$`status` %in% c("available", "pending", "sold"))) {
        stop(paste("Error! \"", this_object$`status`, "\" cannot be assigned to `status`. Must be \"available\", \"pending\", \"sold\".", sep = ""))
      }
      self$`status` <- this_object$`status`
      self
    },

    #' @description
    #' Validate JSON input with respect to Pet and throw an exception if invalid
    #'
    #' @param input the JSON input
    validateJSON = function(input) {
      input_json <- jsonlite::fromJSON(input)
      # check the required field `name`
      if (!is.null(input_json$`name`)) {
        if (!(is.character(input_json$`name`) && length(input_json$`name`) == 1)) {
          stop(paste("Error! Invalid data for `name`. Must be a string:", input_json$`name`))
        }
      } else {
        stop(paste("The JSON input `", input, "` is invalid for Pet: the required field `name` is missing."))
      }
      # check the required field `photoUrls`
      if (!is.null(input_json$`photoUrls`)) {
        stopifnot(is.vector(input_json$`photoUrls`), length(input_json$`photoUrls`) != 0)
        tmp <- sapply(input_json$`photoUrls`, function(x) stopifnot(is.character(x)))
      } else {
        stop(paste("The JSON input `", input, "` is invalid for Pet: the required field `photoUrls` is missing."))
      }
    },

    #' @description
    #' To string (JSON format)
    #'
    #' @return String representation of Pet
    toString = function() {
      self$toJSONString()
    },

    #' @description
    #' Return true if the values in all fields are valid.
    #'
    #' @return true if the values in all fields are valid.
    isValid = function() {
      # check if the required `name` is null
      if (is.null(self$`name`)) {
        return(FALSE)
      }

      # check if the required `photoUrls` is null
      if (is.null(self$`photoUrls`)) {
        return(FALSE)
      }

      TRUE
    },

    #' @description
    #' Return a list of invalid fields (if any).
    #'
    #' @return A list of invalid fields (if any).
    getInvalidFields = function() {
      invalid_fields <- list()
      # check if the required `name` is null
      if (is.null(self$`name`)) {
        invalid_fields["name"] <- "Non-nullable required field `name` cannot be null."
      }

      # check if the required `photoUrls` is null
      if (is.null(self$`photoUrls`)) {
        invalid_fields["photoUrls"] <- "Non-nullable required field `photoUrls` cannot be null."
      }

      invalid_fields
    },

    #' @description
    #' Print the object
    print = function() {
      print(jsonlite::prettify(self$toJSONString()))
      invisible(self)
    }
  ),
  # Lock the class to prevent modifications to the method or field
  lock_class = TRUE
)
## Uncomment below to unlock the class to allow modifications of the method or field
# Pet$unlock()
#
## Below is an example to define the print function
# Pet$set("public", "print", function(...) {
#   print(jsonlite::prettify(self$toJSONString()))
#   invisible(self)
# })
## Uncomment below to lock the class to prevent modifications to the method or field
# Pet$lock()

