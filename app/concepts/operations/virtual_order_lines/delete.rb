# frozen_string_literal: true

module Operations
  module VirtualOrderLines
    # Class to manage operation of delete a product
    class Delete < Trailblazer::Operation
      step :delete_virtual_order_line

      def delete_virtual_order_line(_ctx, params:, virtual_order:, **)
        pp virtual_order.reject! { |line| line['id'] == params[:id].to_i }
      end

      # def initialize(id_order_line, virtual_order)
      #   @id_order_line = id_order_line
      #   @virtual_order = virtual_order
      #   super()
      # end
      
      # def call
      #   delete_virtual_order_line
      # end
      
      # private
      
      # def delete_virtual_order_line
      #   @virtual_order.reject { |line| line['id'] == @id_order_line.to_i }
      # end
    end
  end
end
