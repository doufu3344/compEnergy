function out = accumMap(in,c,o,e)
out = in+(abs(c-o)>45).*e;
end