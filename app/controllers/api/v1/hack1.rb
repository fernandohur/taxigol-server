#!/bin/ruby
# Head ends here
(1..100).each do|i|
a=i%5
b=i%3
s=''
s='Fizz'if b<1
s<<'Buzz'if a<1
s=i if a>0&&b>0
puts s
end