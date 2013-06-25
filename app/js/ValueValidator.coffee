window.ValueValidator = ValueValidator ? new Object

$ ->
  ValueValidator.isPresent = (aValue) ->
    if aValue? && aValue != ''
      true
    else
      false
