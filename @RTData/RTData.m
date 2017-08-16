classdef RTData < handle
%RTData Matlab class   
    properties (SetObservable)
        Data
        Time
        nPoints
        tFrame
        fRefresh
    end
    
    properties (Hidden)
        graphics
    end
    
    
        
    
    methods
        function obj=RTData()
           obj.Data=[];
           obj.graphics.axes_handles=[];
           obj.graphics.plot_handles=[];
           obj.graphics.text_handles=[];
           obj.graphics.iFrame=[];
           obj.graphics.nStep=[];
           obj.graphics.dt=[];
           obj.graphics.nRefresh=[];
           
  
           obj.nPoints=[];
           obj.tFrame=[];
           obj.fRefresh=1;
           addlistener(obj,'data','PostSet',@RTData.DataChange);
        end
        
        function obj=addmeasure(obj,t,sensors)
            obj.time(end+1)=t;
            obj.data(end+1,:)=sensors(:);
        end
    end
    
    
    
    methods (Static)  
        function DataChange(metaProp,eventData)
            h=eventData.AffectedObject;
            
            if size(h.data,1)>=2 && isempty(h.nRefresh)
                if isempty(h.dt)
                    h.dt=h.time(2)-h.time(1);
                end
                h.nRefresh=round(1/(h.fRefresh*h.dt));
            end
                
            
            
            if mod(size(h.data,1),h.nRefresh)==0
                
                
                
                    
                
                if isempty(h.tFrame)
      
                    
                    DisplayTime=h.time;
                    DisplayData=h.data;
                else
                    if isempty(h.iFrame)
                        h.iFrame=round(h.tFrame/h.dt);
                    end
                    if isempty(h.nPoints)
                        h.nStep=1;
                    else
                        h.nStep=max(1,round(h.iFrame/h.nPoints));
                    end
                    
                    DisplayTime=h.time(max(1,end-h.iFrame):h.nStep:end);
                    DisplayData=h.data(max(1,end-h.iFrame):h.nStep:end,:);
                end
                
                
                
                    
                if ~isempty(h.plot_handles)      
                    set(h.plot_handles{1},'XData',DisplayTime,'YData',DisplayData(:,1));
                    
                    set(h.plot_handles{2},'XData',DisplayTime,'YData',DisplayData(:,2));
                    
                    child=get(gcf,'Children');
                    for i=1:length(child)
                        axes(child(i))
                        set(gca,'XLim',[DisplayTime(1) DisplayTime(end)]);
                    end
                    if length(h.plot_handles)>2
                        set(h.plot_handles{3},'String',sprintf('%3.2f s',toc));
                    end
                    
                    
                else
                    h.plot_handles{1}=plot(DisplayTime,DisplayData(:,1));
                    h.plot_handles{2}=plot(DisplayTime,DisplayData(:,2));
                end
                
                drawnow
            end
        end
    end
    
end