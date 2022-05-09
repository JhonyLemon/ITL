% h=worldmap("Poland");
% lat0 = [52 52.1]; 
% lon0 = [19 19.1];
% deltalat = [1 1]; 
% deltalon = [1 1]; 
% quiverm(lat0,lon0,deltalat,deltalon,'r')

 %wm = webmap('World Topographic Map');

% point=geopoint();
% point.Latitude=52;
% point.Longitude=19;
% point.Name=52;
% attribspec = makeattribspec(point);
% k=wmmarker(point,"Description",attribspec,"OverlayName","Fazory");
% %wmremove(k);
% point.Name=50;
% %k=wmmarker(point,"Description",attribspec,"OverlayName","Fazory");

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


axesm('mercator','MapLatLimit',[28 47],'MapLonLimit',[-10 37],...
    'Grid','on','Frame','on','MeridianLabel','on','ParallelLabel','on')
geoshow(lat,long,'DisplayType','line','color','b')
waypoints = [36,-5; 36,-2; 38,5; 38,11; 35,13; 33,30; 31.5,32];
[X, Y] = mfwdtran(waypoints(:,1),waypoints(:,2));
arrow([X(1:(end-1)) Y(1:(end-1))], [X(2:end) Y(2:end)])
