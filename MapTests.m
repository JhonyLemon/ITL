% h=worldmap("Poland");
% lat0 = [52 52.1]; 
% lon0 = [19 19.1];
% deltalat = [1 1]; 
% deltalon = [1 1]; 
% quiverm(lat0,lon0,deltalat,deltalon,'r')

%  wm = webmap('World Topographic Map');
%  wmline(wm,[51 51.01],[19 19.01])

% point=geopoint();
% point.Latitude=52;
% point.Longitude=19;
% point.Name=52;
% attribspec = makeattribspec(point);
% k=wmmarker(point,"Description",attribspec,"OverlayName","Fazory");
% %wmremove(k);
% point.Name=50;
%k=wmmarker(point,"Description",attribspec,"OverlayName","Fazory");

% point=geopoint();
% point.Latitude=52;
% point.Longitude=19;
% point.Name=52;
% 
% variable = [point];
% point.Latitude=49;
% point.Longitude=14;
% 
% variable(end+1) = point;
% point.Latitude=55;
% point.Longitude=24;
% 
% variable(end+1) = point;
% point.Latitude=54;
% point.Longitude=15;
% 
% variable(end+1) = point;
% point.Latitude=50;
% point.Longitude=23;
% 
% variable(end+1) = point;
% point.Latitude=54;
% point.Longitude=23;
% 
% 
% handl=geoaxes('Basemap','topographic');
% p=geoplot(variable.Latitude,variable.Longitude,'Marker','x','Parent',handl,'LineStyle','none','MarkerSize',10,'Color','red','LineWidth',1);
% 
% 
% while true
%     [lat,lon] = ginput(1);
%         for i=1:length(variable)
%            d=distance(lat,lon,variable(i,1).Latitude,variable(i,1).Longitude);
%            distances(i)=d;
%         end
%         [M,I] = min(distances);
%         if M<=0.3
%             disp(variable(I));
%         end
%         
% end


% axesm('mercator','MapLatLimit',[28 47],'MapLonLimit',[-10 37],...
%     'Grid','on','Frame','on','MeridianLabel','on','ParallelLabel','on')
% geoshow(lat,long,'DisplayType','line','color','b')
% waypoints = [36,-5; 36,-2; 38,5; 38,11; 35,13; 33,30; 31.5,32];
% [X, Y] = mfwdtran(waypoints(:,1),waypoints(:,2));
% arrow([X(1:(end-1)) Y(1:(end-1))], [X(2:end) Y(2:end)])

%plot_arrow_geoplot([51 19;51 19],[51.1 19.1;51.1 19.1],'color','r','LineWidth',2);

% function plot_arrow_geoplot(begin_point,end_point,varargin)
% if ~(isvector(begin_point) && length(begin_point)==2)
%    error('begin_point is not a 2D vector') 
% end
% if ~(isvector(end_point) && length(end_point)==2)
%    error('end_point is not a 2D vector') 
% end
% begin_point = begin_point(:)';
% end_point = end_point(:)';
% pivot_x = end_point(1);
% pivot_y = end_point(2);
% theta = 20;
% px = begin_point(1);
% py = begin_point(2);
% s = sind(theta);
% c = cosd(theta);
% px = (px - pivot_x)*0.4;
% py = (py - pivot_y)*0.4;
% xnew = px * c - py * s;
% ynew = px * s + py * c;
% px = xnew + pivot_x;
% py = ynew + pivot_y;
% theta = -20;
% px2 = begin_point(1);
% py2 = begin_point(2);
% s = sind(theta);
% c = cosd(theta);
% px2 = (px2 - pivot_x)*0.4;
% py2 = (py2 - pivot_y)*0.4;
% xnew = px2 * c - py2 * s;
% ynew = px2 * s + py2 * c;
% px2 = xnew + pivot_x;
% py2 = ynew + pivot_y;
% % plot
% geoplot([begin_point(1) end_point(1)],[begin_point(2) end_point(2)],... % line
%     [px end_point(1)],[py end_point(2)],... % arrow end first part
%     [px2 end_point(1)],[py2 end_point(2)],varargin{:}) % arrow end second part
% end


handle=geoaxes('Basemap','topographic');
latLim=[51 53];
lonLim=[18 20];
%DrawOnGeoPlot(handle,[52 52 52 52 52 52 52 52 52 52 52 52],[19 19 19 19 19 19 19 19 19 19 19 19],[deg2rad(0) deg2rad(30) deg2rad(60) deg2rad(90) deg2rad(120) deg2rad(150) deg2rad(180) ...
%    deg2rad(210) deg2rad(240) deg2rad(270) deg2rad(300) deg2rad(330)])

a=0;
b=0;
%while true

DrawOnGeoPlot(handle,[45 44],[0 0],[deg2rad(a) deg2rad(b)],[0.2 0.1],latLim,lonLim);
%a=a+5;
%b=b-5;
%pause(0.5);
%end


