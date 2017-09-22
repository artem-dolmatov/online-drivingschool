var ready;
ready = function() {

	// slick carousel
	var carousel = $('.slick-carousel');
	carousel.each(function(){
		var _this = $(this);
		_this.slick({
			infinite: true,
			slidesToShow: 6,
			slidesToScroll: 1,
			initialSlide: 0
		});

		var prev = _this.find('.slick-prev');
		var next = _this.find('.slick-next');
		prev.html('<i class="icon-carousel-prev"></i>');
		next.html('<i class="icon-carousel-next"></i>');
	});

	// scroll to top
	$('body').on('click', 'a.nav-scroll', function(event){
		$('html,body').scrollTo(this.hash, this.hash, {offset: 0});
	});

	// pickdate
	var pickdate_default = {
		'monthsFull': ['Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь' ],
		'monthsShort': [ 'Янв', 'Февр', 'Март', 'Апр', 'Май', 'Июнь', 'Июль', 'Авг', 'Сент', 'Окт', 'Нояб', 'Дек' ],
		'weekdaysFull': [ 'Воскресенье', 'Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота' ],
		'weekdaysShort': [ 'Вс', 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб' ],
		'format': 'dd.mm.yyyy',
		'formatSubmit': 'yyyy/mm/dd',
		'hiddenPrefix': 'prefix__',
		'hiddenSuffix': '__suffix',
		'today': 'Сегодня',
		'clear': 'Очистить',
		'close': 'Закрыть',
		'firstDay': 1,
		'selectMonths': true,
		'selectYears': 100,
		'max': true
	};

	var $datepicker = $('.datepicker').pickadate(pickdate_default);
	var datepicker = $datepicker.pickadate('picker');

};

$(document).ready(ready);
$(document).on('page:load', ready);