do ($ = window.jQuery) ->

	# initializer
	tableNav = (opts) ->
		$.each $(@.selector), (idx, table) ->
			options = {}
			options.table = $(table) # selector to get the table (or other element) that has content that should be paginated
			options.childSelector = opts.childSelector ? 'tr' # selector to get the content (within the tableSelector) that should be paginated
			options.paginationSelector = opts.pagination ? options.table.siblings('.pagination') # selector to get the pagination element (typically a <div class='pagination'>, see Bootstrap Pagination examples)
			options.itemsPerPage = opts.itemsPerPage ? 10 # number of children to display per pagination page
			options.hideWhenOnePage = opts.hideWhenOnePage ? true
			options.currentPage = opts.initialPage ? 0
			# wire ourselves up
			$(options.paginationSelector).on 'click', 'li', options, onPageNav
			# draw ourselves
			paint(options)

	# nav computations
	startIndexForPage = (options, page) -> options.itemsPerPage * page
	endIndexForPage = (options, page) -> startIndexForPage(options, page + 1) - 1
	getRows = (options) -> options.table.find(options.childSelector)
	numPages = (options) -> Math.ceil(getRows(options).length / options.itemsPerPage)

	paint = (options) ->
		paintTableRows(options)
		paintPagination(options)

	onPageNav = (ev) =>
		ev.data.currentPage = parseInt $(ev.target).attr('data-page-num')
		paint(ev.data)

	paintTableRows = (options) ->
		startRow = startIndexForPage(options, options.currentPage)
		endRow = endIndexForPage(options, options.currentPage)
		options.table.find("#{options.childSelector}:hidden").show()
		options.table.find("#{options.childSelector}:lt(#{startRow})").hide()
		options.table.find("#{options.childSelector}:gt(#{endRow})").hide()

	paintPagination = (options) ->
		num = numPages(options)
		pagination = $(options.paginationSelector)
		# bail early if the table will fit on one page
		return pagination.hide() if num is 1 and options.hideWhenOnePage
		markup = []
		for i in [0...num]
			cssClass = if i is options.currentPage then 'active' else ''
			markup.push "<li class='#{cssClass}'><a href='#' data-page-num='#{i}'>#{i+1}</a></li>"
		pagination.show().empty().append "<ul>#{markup.join ''}</ul>"

	$.extend jQuery.fn,
		tableNav: tableNav
