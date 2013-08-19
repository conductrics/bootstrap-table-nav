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
			options.alignLastPage = opts.alignLastPage ? true
			options.paginationSize = opts.paginationSize ? 5
			options.showAdditionalControls = opts.showAdditionalControls ? false
			if numPages(options) > options.paginationSize
				options.showAdditionalControls = true
			# wire ourselves up
			$(options.paginationSelector).on 'click', 'li', options, onPageNav
			# align table
			alignTable(options)
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
		if options.showAdditionalControls
			markup.push paginationItem(options, 0, "&laquo;") if num > options.paginationSize
			markup.push paginationItem(options, Math.max(0, options.currentPage - 1), "&lsaquo;")
		for i in paginationRange(options, num)
			markup.push paginationItem(options, i, i+1)
		if options.showAdditionalControls
			markup.push paginationItem(options, Math.min(num-1, options.currentPage + 1), "&rsaquo;")
			markup.push paginationItem(options, num-1, "&raquo;") if num > options.paginationSize
		pagination.show().empty().append "<ul>#{markup.join ''}</ul>"

	alignTable = (options) ->
		rowsToAdd = options.itemsPerPage - realMod(getRows(options).length, options.itemsPerPage)
		parent = options.table.find(options.childSelector).parent()
		numCol = $(options.table.find(options.childSelector)[0]).children().length
		parent.append( Array(rowsToAdd+1).join('<tr><td colspan="' + numCol + '">&ensp;</td></tr>') )

	realMod = (n, base) ->
		unless (jsmod = n % base) and ((n > 0) != (base > 0)) then jsmod
		else jsmod + base

	paginationRange = (options, size) ->
		if options.paginationSize >= size then [0...size]
		else
			start = Math.max(0, options.currentPage - Math.floor(options.paginationSize / 2) )
			end = start + options.paginationSize
			if end > size
				start = start + size - end
				end = size
			[start...end]

	paginationItem = (options, value, name) ->
		cssClass = if value is options.currentPage then 'active' else ''
		"<li class='#{cssClass}'><a href='#' data-page-num='#{value}'>#{name}</a></li>"

	$.extend jQuery.fn,
		tableNav: tableNav
