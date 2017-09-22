'use strict';


// Main area
(function($) {

	var question_class = '.question',
		answer_class = '.answer',
		radio_class = 'input[type="radio"]',
		radio_disable_class = 'radio-disabled',
		btn_next_question_class = '.next-question',
		question_link_class = '.question_link',
		get_result_class = '.get-result',
		radio_help_class = '.radio-help';

	var question = $(question_class),
		btn_next_question = $(btn_next_question_class),
		get_result = $(get_result_class),
		question_link = $(question_link_class),
		answers = question.find(answer_class),
		radio = answers.find(radio_class);

	$('body').on('change', '#more-questions input[type="radio"]', function(){
		var _this = $(this),
				question = _this.parents(question_class),
				answer = _this.parents(answer_class),
				answers = question.find(answer_class).not(answer),
				btn_next_question = question.find(btn_next_question_class),
				get_result = question.find(get_result_class),
				radio_help = answer.find(radio_help_class);

		if (_this.data('correct') == 0 && _this.parents('#more-questions').length > 0) {
			$.magnificPopup.close({
				removalDelay: 500, //delay removal by X to allow out-animation,
				items: {
					src: '#more-questions'
				}
			});

			// $('#more-questions').empty();

			$('.get-result').click();
		}

		if (_this.prop('checked')) {
			question.find(radio_help_class).slideUp(300);
			radio_help.slideDown(300);
			answers.addClass(radio_disable_class);
			answers.find(radio_class).prop('disabled', 'disabled');

			btn_next_question.removeClass('disabled');
			get_result.removeClass('disabled');
		}
	});

	radio.on('change', function(e){

		var _this = $(this),
			question = _this.parents(question_class),
			answer = _this.parents(answer_class),
			answers = question.find(answer_class).not(answer),
			btn_next_question = question.find(btn_next_question_class),
			get_result = question.find(get_result_class),
			radio_help = answer.find(radio_help_class);

		if (_this.data('correct') == 0 && _this.parents('#more-questions').length == 0) {

			var success = 0,
					errors = 0;

			var radios = answers.find(radio_class + ':checked');

			radios.each(function(){
				var _this = $(this),
						correct = parseInt(_this.data('correct'));

				if (correct == 0) {
					errors += 1;
				} else if (correct == 1) {
					success += 1;
				}
			});

			if (errors == 3) {
				get_result.click()
			} else {
				if ($('.is-exam').length > 0) {
					$.ajax({
						url: '/admin/load_error_topic',
						type: 'GET',
						// dataType: 'json',
						data: {
							no_answer: _this.val()
						},
						beforeSend: function (xhr) {
							xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
						}
					}).done(function (result) {

						$.magnificPopup.open({
							// enableEscapeKey: false,
							// closeOnContentClick: false,
							modal: true,
							removalDelay: 500, //delay removal by X to allow out-animation,
							items: {
								src: '#more-questions'
							}
						});

					}).fail(function () {
						console.log("Произошла ошибка");
					});
				}
			}


			// console.log(_this.val())

		}

		if (_this.prop('checked')) {
			question.find(radio_help_class).slideUp(300);
			radio_help.slideDown(300);
			answers.addClass(radio_disable_class);
			answers.find(radio_class).prop('disabled', 'disabled');

			btn_next_question.removeClass('disabled');
			get_result.removeClass('disabled');
		}

	});

	$('body').on('click', '.next-question', function(e){
		e.preventDefault();

		var _this = $(this),
		    tab = _this.attr('href');

		$(tab).tab('show');
	});


	$('body').on('click', '#more-questions .get-result', function(e){
		e.preventDefault();

		$.magnificPopup.close({
			removalDelay: 500, //delay removal by X to allow out-animation,
			items: {
				src: '#more-questions'
			}
		});

	});

	get_result.on('click', function(e){
		e.preventDefault();

		var _this = $(this),
			topic_id = _this.data('id'),
			tab = _this.attr('href'),
			result_test = $('#result_test').data('last');


		var success = 0,
			errors = 0;

		var radios = $(radio_class + ':checked');

		// var radios = answers.find(radio_class + ':checked');

		radios.each(function(){
			var _this = $(this),
				correct = parseInt(_this.data('correct'));

			if (correct == 0) {
				errors += 1;
			} else if (correct == 1) {
				success += 1;
			}
		});

		var add_radios = $('#more-questions').find(radio_class + ':checked');

		add_radios.each(function(){
			var _this = $(this),
					correct = parseInt(_this.data('correct'));

			if (correct == 0) {
				errors = 3;
			}
		});

		if (errors < 3) {
			$('.next-lecture').removeClass('hidden');

			if (result_test) {

				$('.next-exam').removeClass('hidden');
			}

			$.ajax({
				url: '/admin/student/topics/done',
				type: 'POST',
				dataType: 'json',
				data: {
					topic_id: topic_id
				},
				beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))}
			}).done(function(result) {

			}).fail(function() {
				console.log("Произошла ошибка");
			});

		} else {
			$('.information').removeClass('hidden');
			$('.test-goodbye').text('Тест не пройден!');
			$('.exam-goodbye').text('Экзамен не пройден');

		}

		$('.success-result').text(success);
		$('.error-result').text(errors);

		$(tab).tab('show');
	});

	question_link.on('click', function(e){e.preventDefault()});

})(jQuery);

