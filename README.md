bootstrap-table-nav
===================

Very basic jQuery plugin that makes a HTML table "pageable" with a Bootstrap-style "pagination" component.

# Installation

The plugin is meant to be used with Twitter Bootstrap. I am using it with Bootstrap 2.3.1 at the time of this writing.

Just include the script in your page, after jQuery and Bootstrap.

```
<script src="bootstrap-table-nav.js"></script>
```

Then put a `table` on your page, and a Bootstrap `pagination` component:
```
<table id="myTable">
	<tr><td>My row 1</td></tr>
	<tr><td>My row 2</td></tr>
</table>
<div class="pagination"></div>
```

Then call tableNav() like so:
```
$(document).ready(function() { // assuming the table will exist at document.ready

  $('#myTable').tableNav()

});
```

There are some options you can provide:
* **itemsPerPage** - a number which indicates how many table rows should show per "page". The default is 10, so a table with 25 `<row>` elements will be shown in 3 pages (5 on the last page).
* **hideWhenOnePage** - The default is true, which means the pagination component is hidden when all the rows would fit on one page. Set to false to show the component anyway (even though it will just show one page to nav to, labelled `1`).
* **initialPage** - A number to indicate which page the table should show initially.
* **childSelector** - a jQuery selector that finds the children of the table. By default this is `tr` which is usually fine.
* **paginationSelector** - a jQuery selector that finds the pagination component for the table. If not provided, will look for a sibling of the table with class `pagination`.
* **alignLastPage** - The default is true, which means empty rows are added to the table to ensure that the last page has the same height like the previous ones.
* **paginationSize** - a number which indicates how many elements are shown in the pagination. The default is 5. The shown range will adjust to the current page. In addition the following buttons are added: 'first page', 'previous page', 'next page', 'last page'. These buttons are not shown if all page element can be displayed.
* **showAdditionalControls** - Shows the 'previous page' and 'next page' button even if all page elements can be displayed. The default is false.

For instance:
```
  $('#myTable').tableNav({
  	itemsPerPage: 5
  })
```
There is a simple demo in the 'demo' folder.

## TODOs

* Support a simple filtering mechanism
* Possibly add column sorting

LICENSE: MIT
