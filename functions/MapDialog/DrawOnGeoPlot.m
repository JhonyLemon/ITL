function DrawOnGeoPlot(handle,latitude,longitude,angle,magnitude,latLim,lonLim)
% Used to draw arrows on geoaxes
arguments
    handle
    latitude
    longitude
    angle
    magnitude
    latLim
    lonLim
end
    if ishandle(handle) 
        if isvalid(handle) && size(latitude,2)==size(longitude,2) && size(longitude,2)==size(angle,2)
            N=size(latitude,2);
            beta=zeros(1,N);
            alpha=zeros(1,N);
            beta(:)=deg2rad(180-20);
            alpha(:)=deg2rad(180+20);
            
            lineEndPointLat=latitude+magnitude.*sin(angle);
            lineEndPointLon=longitude+magnitude.*cos(angle);
            leftArrowEndLat=lineEndPointLat+0.04*sin(beta+angle);
            leftArrowEndLon=lineEndPointLon+0.04*cos(beta+angle);
            rightArrowEndLat=lineEndPointLat+0.04*sin(alpha+angle);
            rightArrowEndLon=lineEndPointLon+0.04*cos(alpha+angle);
            
            for i=1:N
            geoplot(handle,[latitude(i) lineEndPointLat(i)],[longitude(i) lineEndPointLon(i)], ...
                 [lineEndPointLat(i),rightArrowEndLat(i)],[lineEndPointLon(i),rightArrowEndLon(i)], ...
                 [lineEndPointLat(i),leftArrowEndLat(i)],[lineEndPointLon(i),leftArrowEndLon(i)], ...
                 'color','r','LineWidth',2,'AlignVertexCenters','off');
            hold(handle,"on");
            end
            hold(handle,"off");
                if size(latLim,2)~=0 && size(lonLim,2)~=0
                geolimits(handle,latLim,lonLim);
                end
        end
    end
end