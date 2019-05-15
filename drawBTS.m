% load relevant data
relevant_lon = lon(relevant_data);
relevant_lat = lat(relevant_data);
relevant_network = networkCode(relevant_data);

% define what color each bts shall be
if relevant_network == 1
    plot(relevant_lon,relevant_lat,'m.','MarkerSize',15)
elseif relevant_network == 2
    plot(relevant_lon,relevant_lat,'r.','MarkerSize', 15)
elseif relevant_network == 3
    plot(relevant_lon,relevant_lat,'g.','MarkerSize', 15)
elseif relevant_network == 7
    plot(relevant_lon,relevant_lat,'b.','MarkerSize', 15)
else
    plot(relevant_lon,relevant_lat,'k.','MarkerSize', 15)
end
