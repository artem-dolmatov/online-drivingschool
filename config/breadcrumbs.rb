crumb :root do
	link 'Главная', admin_root_path
end

crumb :general do |links|
	links.each do |key, value|
		link key, (value == 'blank' ? '' : eval(value))
	end
end