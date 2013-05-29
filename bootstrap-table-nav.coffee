do ($ = window.jQuery) ->
	options = {}
	current = {}

	# initializer
	tableNav = (opts) ->
		options.tableSelector = @.selector # selector to get the table (or other element) that has content that should be paginated
		options.childSelector = opts.childSelector ? 'tr' # selector to get the content (within the tableSelector) that should be paginated
		options.paginationSelector = opts.pagination ? $(options.tableSelector).siblings('.pagination') # selector to get the pagination element (typically a <div class='pagination'>, see Bootstrap Pagination examples)
		options.itemsPerPage = opts.itemsPerPage ? 10 # number of children to display per pagination page
		options.hideWhenOnePage = opts.hideWhenOnePage ? true
		current.page = opts.initialPage ? 0
		# wire ourselves up
		$(options.paginationSelector).on 'click', 'li', onPageNav
		# draw ourselves
		paint()

	# nav computations
	startIndexForPage = (page) -> options.itemsPerPage * page
	endIndexForPage = (page) -> startIndexForPage(page + 1) - 1
	getRows = -> $(options.tableSelector).find(options.childSelector)
	numPages = ->  Math.ceil(getRows().length / options.itemsPerPage)

	paint = ->
		paintTableRows()
		paintPagination()

	onPageNav = (ev) =>
		current.page = parseInt $(ev.target).attr('data-page-num')
		paint()

	paintTableRows = ->
		startRow = startIndexForPage current.page
		endRow = endIndexForPage current.page
		table = $(options.tableSelector)
		table.find("#{options.childSelector}:hidden").show()
		table.find("#{options.childSelector}:lt(#{startRow})").hide()
		table.find("#{options.childSelector}:gt(#{endRow})").hide()

	paintPagination = ->
		num = numPages()
		pagination = $(options.paginationSelector)
		# bail early if the table will fit on one page
		return pagination.hide() if num is 1 and options.hideWhenOnePage
		markup = []
		for i in [0...num]
			cssClass = if i is current.page then 'active' else ''
			markup.push "<li class='#{cssClass}'><a href='#' data-page-num='#{i}'>#{i+1}</a></li>"
		pagination.show().empty().append "<ul>#{markup.join ''}</ul>"

	$.extend jQuery.fn,
		tableNav: tableNav
