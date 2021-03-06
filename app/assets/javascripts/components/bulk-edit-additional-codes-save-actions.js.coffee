window.BulkEditAdditionalCodesSaveActions =

  sendSaveRequest: (mode) ->
    bottom_limit = (window.__sb_current_batch - 1) * window.__sb_per_page
    top_limit = bottom_limit + window.__sb_per_page
    final_batch = false

    if window.__sb_current_batch == window.__sb_total_pages
      top_limit = window.__sb_total_count
      final_batch = true

    collection = JSON.parse(JSON.stringify(window.__sb_collection))

    data = {
      mode: mode,
      final_batch: final_batch,
      bulk_additional_codes_collection: collection.slice(bottom_limit, top_limit)
    }

    ops = 'page=' + window.__sb_current_batch + '&bottom_limit=' + bottom_limit + '&top_limit=' + top_limit

    $.ajax
      url: '/additional_codes/bulks/' + window.__workbasket_id.toString() + '.json?' + ops
      data: JSON.stringify(data)
      type: 'PUT'
      processData: false
      contentType: 'application/json'
      success: (response) ->
        BulkEditAdditionalCodesSaveActions.cleanUpErrorBlocks(response)
        BulkEditAdditionalCodesSaveActions.sendNextBatch(mode, response)
      error: (response) ->
        BulkEditAdditionalCodesSaveActions.handleErrors(response)
        BulkEditAdditionalCodesSaveActions.sendNextBatch(mode, response)

    return false

  sendNextBatch: (mode, response) ->
    window.__sb_current_batch = window.__sb_current_batch + 1
    if window.__sb_current_batch <= window.__sb_total_pages

      setTimeout (->
        BulkEditAdditionalCodesSaveActions.sendSaveRequest(mode)
      ), 3000
    else
      if mode == "save_group_for_cross_check" && response.redirect_url isnt undefined
        setTimeout (->
          window.location = response.redirect_url
        ), 1000
      else
        BulkEditAdditionalCodesSaveActions.toogleSaveSpinner()
        BulkEditAdditionalCodesSaveActions.unlockButtons()
        BulkEditAdditionalCodesSaveActions.showSummaryPopup()

    return false

  cleanUpErrorBlocks: (response) ->
    $.each response.collection_row_ids, (index, row_id) ->
      measure_parent_div = $("[data-record-sid='" + row_id + "']")
      measure_parent_div.find(".has-validation-errors")
                        .removeClass('has-validation-errors')

  handleErrors: (response) ->
    errored_measures = response.responseJSON["additional_codes_with_errors"]

    $.each errored_measures, (row_id, errored_columns) ->
      measure_parent_div = $("[data-record-sid='" + row_id + "']")

      $.each errored_columns, (index, errored_field_name) ->
        if errored_field_name is "additional_code_sid"
          errored_field_name = "type_id"

        measure_parent_div.find("." + errored_field_name + "-column")
                          .addClass('has-validation-errors')

  getValidationErrors: ->
    $(document).on 'click', '.additional_codes .has-validation-errors', ->
      row_id = $(this).closest("tr")
                           .attr("data-record-sid")

      type = $(this).attr("class")
                    .replace("table__column", "")
                    .replace("has-validation-errors", "")

      $.ajax
        url: '/additional_codes/bulks/' + window.__workbasket_id.toString() + '/bulk_items/validation_details.js'
        data: { row_id: row_id, type: type }
        type: 'GET'
        contentType: 'application/json'

      return false

  toogleSaveSpinner: ->
    mode = window.__save_bulk_edit_mode
    BulkEditAdditionalCodesSaveActions.disable_other_buttons()

    if mode == "save_progress"
      link = $(".js-bulk-edit-of-records-save-progress")
      spinner = $(".js-bulk-edit-of-records-save-progress-spinner")
    else
      link = $(".js-bulk-edit-of-records-submit-for-cross-check")
      spinner = $(".js-bulk-edit-of-records-submit-for-cross-check-spinner")

    if link.hasClass('hidden')
      spinner.addClass('hidden')
      link.addClass('secondary-button')
      link.removeClass('hidden')
    else
      link.removeClass('secondary-button')
      link.addClass('hidden')
      spinner.removeClass('hidden')

  disable_other_buttons: ->
    save_link = $(".js-bulk-edit-of-records-save-progress")
    submit_link = $(".js-bulk-edit-of-records-submit-for-cross-check")
    exit_link = $(".js-bulk-edit-of-records-exit")

    mode = window.__save_bulk_edit_mode

    if mode == "save_progress"
      submit_link.addClass('disabled')
    else
      save_link.addClass('disabled')

    exit_link.addClass('disabled')

  unlockButtons: ->
    $(".js-bulk-edit-of-records-save-progress").removeClass('disabled')
    $(".js-bulk-edit-of-records-submit-for-cross-check").removeClass('disabled')
    $(".js-bulk-edit-of-records-exit").removeClass('disabled')

  showSummaryPopup: ->
    modal_id = "bem-save-progress-summary"
    content = "There are no conformance errors"

    if $(".has-validation-errors").length > 0
      content = "Some additional codes have conformance errors, please review table cells with highlighted in red"

    if window.__save_bulk_edit_mode == "save_group_for_cross_check"
      if $(".has-validation-errors").length > 0
        modal_id = "bem-submit-summary-failed"
      else
        modal_id = "bem-submit-summary-success"
        content = "You have submitted your work for cross-check"

    content_container = $("#" + modal_id + " .js-bem-popup-data-container")
    content_container.html(content)
    MicroModal.show(modal_id)

    window.__save_bulk_edit_mode = null

    return false

$ ->
  BulkEditAdditionalCodesSaveActions.getValidationErrors()

