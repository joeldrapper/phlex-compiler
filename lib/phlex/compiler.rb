# frozen_string_literal: true

require "phlex"
require "syntax_tree"

module Phlex
	class Compiler
		Loader = Zeitwerk::Loader.new.tap do |loader|
			loader.push_dir("#{__dir__}/compiler", namespace: Phlex::Compiler)
			loader.inflector = Zeitwerk::GemInflector.new(__FILE__)
			loader.inflector.inflect "fcall" => "FCall", "vcall" => "VCall"
			loader.setup
		end

		def initialize(view)
			@view = view
		end

		attr_writer :scope

		def inspect
			"#{self.class.name} for #{@view.name} view class"
		end

		def call
			Visitors::File.new(self).visit(tree)
		end

		def tag_method?(method_name)
			(HTML::STANDARD_ELEMENTS.key?(method_name) || HTML::VOID_ELEMENTS.key?(method_name)) && !redefined?(method_name)
		end

		def redefined?(method_name)
			prototype = @view.allocate

			@view.instance_method(method_name).bind(prototype) !=
				Phlex::HTML.instance_method(method_name).bind(prototype)
		end

		def redefine(method, line:)
			patch = scope + method + unscope
			eval(patch, Kernel.binding, file, (line - 1))
		end

		def scope
			@scope.map do |scope|
				case scope
					in SyntaxTree::ModuleDeclaration then "module #{scope.constant.constant.value};"
					in SyntaxTree::ClassDeclaration then "class #{scope.constant.constant.value};"
				end
			end.join + "\n"
		end

		def unscope
			"; end" * @scope.size
		end

		def line
			location[1]
		end

		private

		def tree
			@tree ||= SyntaxTree.parse(source)
		end

		def source
			SyntaxTree.read(file)
		end

		def file
			location[0]
		end

		def location
			::Module.const_source_location(@view.name)
		end
	end
end
