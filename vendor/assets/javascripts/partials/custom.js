'use strict';
//  Author: AdminDesigns.com
// 
//  This file is reserved for changes made by the use. 
//  Always seperate your work from the theme. It makes
//  modifications, and future theme updates much easier 
//

//  Unit functions
var CleanPastedHTML = function (input) {
	// 1. remove line breaks / Mso classes
	var stringStripper = /(\n|\r| class=(")?Mso[a-zA-Z]+(")?)/g;
	var output = input.replace(stringStripper, ' ');
	// 2. strip Word generated HTML comments
	var commentSripper = new RegExp('<!--(.*?)-->','g');
	var output = output.replace(commentSripper, '');
	var tagStripper = new RegExp('<(/)*(meta|link|span|\\?xml:|st1:|o:|font)(.*?)>','gi');
	// 3. remove tags leave content if any
	output = output.replace(tagStripper, '');
	// 4. Remove everything in between and including tags '<style(.)style(.)>'
	var badTags = ['style', 'script','applet','embed','noframes','noscript'];

	for (var i=0; i< badTags.length; i++) {
		tagStripper = new RegExp('<'+badTags[i]+'.*?'+badTags[i]+'(.*?)>', 'gi');
		output = output.replace(tagStripper, '');
	}
	// 5. remove attributes ' style="..."'
	var badAttributes = ['style', 'start'];
	for (var i=0; i< badAttributes.length; i++) {
		var attributeStripper = new RegExp(' ' + badAttributes[i] + '="(.*?)"','gi');
		output = output.replace(attributeStripper, '');
	}
	return output;
};

var model_remove_window = function() {
	$.magnificPopup.close({
		removalDelay: 500, //delay removal by X to allow out-animation,
		items: {
			src: '#remove-modal'
		}
	});
};


// Main area
(function($) {

	// Init Theme Core
	Core.init();

	// Init Select2 - Basic Single
	var admin_select_single = $(".admin-form__select2-single");
	admin_select_single.select2({
		allowClear: true,
		placeholder: $(this).data('placeholder')
	});

	admin_select_single.on('change', function() {  // when the value changes
		$(this).valid(); // trigger validation on this element
	});

	// Init Ladda Plugin on buttons
	var labba = Ladda;
	labba.bind('.ladda-button', {
		//timeout: 10000
	});

	// Init Ladda Plugin on buttons
	labba.bind('.admin-form__submit-link', {
		timeout: 2000
	});

	// AdminPanels Plugin
	var panels = $('.admin-panels');
	panels.adminpanel({
		grid: '.admin-grid',
		draggable: false,
		mobile: false,
		callback: function() {
			//bootbox.confirm('<h3>A Custom Callback!</h3>', function() {});
		},
		onStart: function() {
			// Do something before AdminPanels runs
		},
		onFinish: function() {
			// Create an example admin panel filter
			$('#admin-panel-filter a').on('click', function() {
				var _this = $(this);
				var value = _this.attr('data-filter');

				// Toggle any elements whos name matches
				// that of the buttons attr value
				$('.admin-filter-panels').find($(value)).each(function(i, e) {
					if (_this.hasClass('active')) {
						$(this).slideDown('fast').removeClass('panel-filtered');
					} else {
						$(this).slideUp().addClass('panel-filtered');
					}
				});
				_this.toggleClass('active');
			});

		},
		onSave: function() {
			$(window).trigger('resize');
		}
	});

	//  fullscreen - [start]
	var selector = $('html');

	var ua = window.navigator.userAgent;
	var old_ie = ua.indexOf('MSIE ');
	var new_ie = ua.indexOf('Trident/');
	if ((old_ie > -1) || (new_ie > -1)) { selector = $('body'); }

	// Fullscreen Functionality
	var screenCheck = $.fullscreen.isNativelySupported();

	// Attach handler to navbar fullscreen button
	$('.request-fullscreen').on('click', function() {

		// Check for fullscreen browser support
		if (screenCheck) {
			if ($.fullscreen.isFullScreen()) {
				$.fullscreen.exit();
			}
			else {
				selector.fullscreen({
					overflow: 'auto'
				});
			}
		} else {
			alert('Your browser does not support fullscreen mode.')
		}
	});
	//  fullscreen - [end]

	// dataTable - [start]
	var table = $('.data-table');
	var data_table = table.DataTable({
		"aoColumnDefs": [
			{ 'bSortable': false, 'aTargets': [ table.data('sort_disable') ] }
		],
		"aaSorting": [[table.data('sort_column'), table.data('sort_default')]],
		"oLanguage": {
			"sSearch": "<span>Поиск:</span>",
			"sLengthMenu": "<span>_MENU_</span>",
			"sProcessing": "Подождите...",
			"lengthMenu": "Показать _MENU_ записей",
			"sInfo": "Записи с _START_ до _END_ из _TOTAL_ записей",
			"sInfoEmpty": "Записи с 0 до 0 из 0 записей",
			"sInfoFiltered": "(отфильтровано из _MAX_ записей)",
			"sInfoPostFix": "",
			"sLoadingRecords": "Загрузка записей...",
			"sZeroRecords": "Записи отсутствуют.",
			"sEmptyTable": "В таблице отсутствуют данные",
			"oPaginate": {
				"sFirst": "Первая",
				"sPrevious": "Предыдущая",
				"sNext": "Следующая",
				"sLast": "Последняя"
			},
			"aria": {
				"sortAscending": ": активировать для сортировки столбца по возрастанию",
				"sortDescending": ": активировать для сортировки столбца по убыванию"
			}
		},
		"iDisplayLength": table.data('display_length'),
		"aLengthMenu": [
			[5, 10, 25, 50, -1],
			[5, 10, 25, 50, "Все"]
		],
		"sDom": '<"dt-panelmenu clearfix"lfr><"data-table-wrapper"t><"dt-panelfooter clearfix"ip>',
		// "sDom": '<"dt-panelmenu clearfix"lfr>t<"dt-panelfooter clearfix"ip>',
		"bStateSave": true
	});

	var filter_table = $('.filter-table');
	if (filter_table.length > 0) {

		//DataTables_data-table-classic_qualificationcommissionroute_/admin/qualification_commission_route
		var local_storage_id = 'DataTables_' + table.prop('id') + '_'+ window.location.pathname;
		var json_data = jQuery.parseJSON(localStorage.getItem(local_storage_id));


		var td = filter_table.find("tfoot td");
		td.not('.action').each( function ( i ) {

			var local_storage_val = json_data.columns[i].search.search.slice(1, -1);

			//console.log(local_storage_val);

			var select = $('<select class=' + i + '><option value="">&nbsp;</option></select>')
				.appendTo($(this).empty())
				.on('change', function () {

					var val = $(this).val();

					data_table.column(i) //Only the first column
						.search(val ? '^' + $(this).val() + '$' : val, true, false)
						.draw();
				});

			data_table.column(i).data().unique().sort().each(function (d, j) {
				if (d.length > 0) {
					select.append('<option value="' + d + '" ' + (d == local_storage_val ? 'selected' : '') + '>' + d + '</option>');
				}
			});
		});

		td.find("select").select2({
			minimumResultsForSearch: Infinity
			//allowClear: true
		});

		filter_table.on('click', '.filter-clear', function(event){
			event.preventDefault();
			console.log('hi');
			$(this).parents('.filter-table').find('select').val("").change();
		})
	}

		// data_table
	$(".dataTables_length select").select2({minimumResultsForSearch: Infinity});
	// dataTable - [end]

	// AdminForm submit - [start]
	$('.admin-form__submit-link').on('click', function(e) {
		e.preventDefault();

		var form = $(this).parents('#admin-form');

		setTimeout(function() {
			// Example animate buttons
			var animateClass = 'animated shake';

			// Simply adds CSS classes required for animation
			// and then removes them after an elapsed time
			var animatedObj = $('.state-error');

			$('body').addClass('animation-running');
			animatedObj.removeClass('fadeIn').addClass(animateClass);

			animatedObj.one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function () {
				$('body').removeClass('animation-running');
				animatedObj.removeClass(animateClass);
			});

			var valid = form.valid();

			if (valid) {
				labba.bind('.admin-form__submit-link', {
					timeout: 15000
				});
				form.submit();
			} else {
				$(document.body).animate({
					"scrollTop": $('#admin-form .field.state-error:first').offset().top - 160
				}, 500, "swing");
			}
		}, 1000);
	});
	// AdminForm submit - [end]

	// Modal for remove record - [start]
	var table_row = '';
	var table_row_get_0 = '';
	//var table_row_button = $('.btn-row-delete');
	var remove_modal = $('#remove-modal');
	var remove_modal__btn__success = remove_modal.find('.remove-modal__remove-button__success');
	var remove_modal__btn__abort = remove_modal.find('.remove-modal__remove-button__abort');

	$('body').on('click', '.btn-row-delete:not(.disabled)', function(e) {
		e.preventDefault();
		var _this = $(this);
		var href = _this.prop('href');
		table_row = _this.closest("tr");
		table_row_get_0 = _this.closest("tr").get(0);
		remove_modal__btn__success.data('href', href);

		var show_in_modal = _this.closest("tr").find('.show_in_modal');
		var show_in_modal_text = '';
		show_in_modal.each(function(){
			show_in_modal_text += $(this).data('show_in_modal_text');
		});

		remove_modal.find('.remove-modal__delete-text').html(show_in_modal_text);

		// magnificPopup init
		$.magnificPopup.open({
			removalDelay: 500, //delay removal by X to allow out-animation,
			items: {
				src: '#remove-modal'
			},
			overflowY: 'hidden', //
			callbacks: {
				beforeOpen: function(e) {
					this.st.mainClass = _this.attr('data-effect');
				}
			},
			midClick: true
		});

	});

	// success modal remove window
	remove_modal__btn__success.on('click', function(e) {
		e.preventDefault();
		var _this = $(this);
		var href = _this.data('href');

		$('.btn-row-delete').addClass('disabled');

		$.ajax({
			url: href,
			type: 'DELETE',
			beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))}
		}).done(function(result) {
			var animated_class = 'animated fadeOutDown';
			model_remove_window();
			table_row.find('td').addClass(animated_class);

			setTimeout(function(){
				var td = table_row.find('td');
				var height = td.height();
				td.height(height)
					.css('border', 0)
					.text('')
					.animate({padding: '0px', height: 0}, {duration: 200});

				setTimeout(function() {
					table.dataTable().fnDeleteRow(table.dataTable().fnGetPosition(table_row.get(0)));

					// Create new Notification
					new PNotify({
						title: 'Действие удаление',
						text: 'Запись успешно удалена',
						shadow: false,
						opacity: 1,
						addclass: '',
						type: 'warning',
						stack: {
							"dir1": "down",
							"dir2": "left",
							"push": "top",
							"spacing1": 10,
							"spacing2": 10
						},
						width: '400px',
						delay: 2500
					});

					$('.btn-row-delete').removeClass('disabled');
				}, 500);
			}, 1000);
		}).fail(function() {
			console.log("remove record is error");
		});
	});

	// abort modal remove window
	remove_modal__btn__abort.on('click', function(e) {
		e.preventDefault();

		model_remove_window();
	});
	// Modal for remove record - [end]

	// Datepicker - [start]
	$.datepicker.regional['ru'] = {
		closeText: 'Закрыть',
		prevText: '&#x3C;Пред',
		nextText: 'След&#x3E;',
		currentText: 'Сегодня',
		monthNames: ['Январь','Февраль','Март','Апрель','Май','Июнь',
			'Июль','Август','Сентябрь','Октябрь','Ноябрь','Декабрь'],
		monthNamesShort: ['Янв','Фев','Мар','Апр','Май','Июн',
			'Июл','Авг','Сен','Окт','Ноя','Дек'],
		dayNames: ['воскресенье','понедельник','вторник','среда','четверг','пятница','суббота'],
		dayNamesShort: ['вск','пнд','втр','срд','чтв','птн','сбт'],
		dayNamesMin: ['Вс','Пн','Вт','Ср','Чт','Пт','Сб'],
		weekHeader: 'Нед',
		dateFormat: 'dd.mm.yy',
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''};

	$.datepicker.setDefaults($.datepicker.regional['ru']);

	var date_picker = $(".datepicker");
	date_picker.datepicker({
		numberOfMonths: date_picker.data('number-month'),
		showButtonPanel: true,
		buttonText: '<i class="fa fa-calendar-o"></i>',
		prevText: '<i class="fa fa-chevron-left"></i>',
		nextText: '<i class="fa fa-chevron-right"></i>',
		dateFormat: "dd.mm.yy",
		firstDay: 1,
		defaultDate: 1,
		beforeShow: function(input, inst) {
			var newclass = 'admin-form';
			var themeClass = $(this).parents('.admin-form').attr('class');
			var smartpikr = inst.dpDiv.parent();
			if (!smartpikr.hasClass(themeClass)) {
				inst.dpDiv.wrap('<div class="' + themeClass + '"></div>');
			}
		}
	}).on('change', function(){
		$(this).valid();
	}).on('click', function(){
		$(this).datepicker('show');
	});
	// Datepicker - [end]


	$('.gui-textarea').on('keydown', function(){
		$(this).valid();
	});

	$('.gui-logical').on('change', function(){
		$(this).valid();
	});


	// multiple select
	var admin_select_multiple = $(".admin-form__select2-multiple");
	admin_select_multiple.select2({
		allowClear: true,
		placeholder: $(this).data('placeholder')
	});

	admin_select_multiple.on('change', function() {  // when the value changes
		$(this).valid(); // trigger validation on this element
	});



	// select like tag
	var admin_select_multiple_tag = $(".admin-form__select2-multiple__tag");

	$.fn.select2.amd.require(['select2/selection/search'], function (Search) {
		var oldRemoveChoice = Search.prototype.searchRemoveChoice;

		Search.prototype.searchRemoveChoice = function () {
			oldRemoveChoice.apply(this, arguments);
			this.$search.val('');
		};

		admin_select_multiple_tag.select2({
			allowClear: true,
			placeholder: $(this).data('placeholder'),
			multiple: true,
			tags: true
		});
	});

	admin_select_multiple_tag.on('change', function() {  // when the value changes
		$(this).valid(); // trigger validation on this element
	});

})(jQuery);

