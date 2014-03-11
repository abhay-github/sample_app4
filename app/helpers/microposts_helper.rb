module MicropostsHelper
	def wrap(content)
		sanitize(raw(content.split.map{ |s| wrap_long_string(s)}.join(' ')))
	end

	def wrap_long_string(s, max_width=30)
		zero_width_space="&#8203"
		regex = /.{1,#{max_width}}/
		s.length < max_width ? s : s.scan(regex).join(zero_width_space)
	end
end