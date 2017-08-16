function AutoPlot(metaProp,eventData)
            h=eventData.AffectedObject;
            
            if numel(h.Time)>=2 && isempty(h.graphics.nRefresh)
                if isempty(h.graphics.dt)
                    h.graphics.dt=h.Time(2)-h.Time(1);
                end
                h.graphics.nRefresh=round(1/(h.fRefresh*h.graphics.dt));
            end
                
            
            
            if mod(numel(h.Time),h.graphics.nRefresh)==0
                
                
                
                    
                
                if isempty(h.tFrame)
      
                    
                    DisplayTime=h.Time;
                    DisplayData=h.Data;
                else
                    if isempty(h.graphics.iFrame)
                        h.graphics.iFrame=round(h.tFrame/h.graphics.dt);
                    end
                    if isempty(h.nPoints)
                        h.graphics.nStep=1;
                    else
                        h.graphics.nStep=max(1,round(h.graphics.iFrame/h.nPoints));
                    end
                    
                    DisplayTime=h.time(max(1,end-h.graphics.iFrame):h.graphics.nStep:end);
                    DisplayData=h.data(max(1,end-h.graphics.iFrame):h.graphics.nStep:end,:);
                end
                
                
                
                    
                if ~isempty(h.graphics.plot_handles)
                    
                    
                    for k=1:numel(h.graphics.plot_handles)  
                        set(h.graphics.plot_handles(k),'XData',DisplayTime,'YData',DisplayData(:,k));
                    end
                    
                    for i=1:numel(h.graphics.axes_handles)
                        set(h.graphics.axes_handles(i),'XLim',[DisplayTime(1) DisplayTime(end)]);
                    end
                    
                    if numel(h.graphics.text_handles)>0
                        set(h.graphics.text_handles(1),'String',sprintf('%3.2f s',toc));
                    end 
                end
                
                
            end
end
        