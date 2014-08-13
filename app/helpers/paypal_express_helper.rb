 module PaypalExpressHelper
 end

#   def get_setup_purchase_params(booking, request)
#     subtotal, shipping, total = get_totals(booking)
#     return to_cents(total), {
#       :ip => request.remote_ip,
#       :return_url => url_for(:action => 'review', :only_path => false),
#       :cancel_return_url => home_url,
#       :subtotal => to_cents(subtotal),
#       :shipping => to_cents(shipping),
#       :handling => 0,
#       :tax =>      0,
#       :allow_note =>  true,
#       :items => get_items(booking),
#     }
#   end
 
#   def get_shipping(booking)
#     # define your own shipping rule based on your booking here
#     # this method should return an integer
#   end
 
#   def get_items(booking)
#     booking.line_items.collect do |line_item|
#       product = line_item.product
 
#       {
#         :name => product.title, 
#         :number => product.serial_number, 
#         :quantity => line_item.quantity, 
#         :amount => to_cents(product.price), 
#       }
#     end
#   end
 
#   def get_totals(booking)
#     subtotald = booking.total
#     shipping = get_shipping(booking)
#     total = subtotal + shipping
#     return subtotal, shipping, total
#   end
 
#   def to_cents(money)
#     (money*100).round
#   end
# end