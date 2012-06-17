module FormForms
  module Elements
    class TableHeaderField < Field
      def initialize(cell_args={}, &generator)
        self.cell_args cell_args
        super(&generator)
      end

      property :cell_args

      def render(builder, view)
        cell_args = eval_property(:cell_args, builder, view)

        view.content_tag(:th, cell_args) do
          super
        end
      end
    end
  end
end
