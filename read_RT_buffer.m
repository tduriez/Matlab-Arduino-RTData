function [time,ss]=read_RT_buffer()

s=serial('/dev/ttyS100');
set(s,'BaudRate',115200)
set(s,'InputBufferSize',512*1000);
fopen(s);

caching(s);

fig=figure;
for i=1:12
    subplot(6,2,i)
    handle_l(i)=line([0 1],[0 1]);
end
hold on;
iacquis=0;
iFrame=0;
time=zeros(10^6*60*2,1);
ss=zeros(10^6*60*2,12);
time_init=0;
tic
t=title('Time');
dt=0;
while ishandle(fig)
    n=get(s,'BytesAvailable');
    nbacquis=floor(n/32);
    if nbacquis==0
        continue;
    end
    aa=fread(s,32*nbacquis,'uint8');
    for nba=1:nbacquis
        iacquis=iacquis+1;
        a=aa(1+32*(nba-1):32*nba);
        time(iacquis)=a(1)*2^24+a(2)*2^16+a(3)*2^8+a(4);
    for k=1:12
        ss(iacquis,k)=a(5+2*(k-1))*2^8+a(6+2*(k-1));
    end
    end
    theend=a(end-3:end);
    
    if time_init==0
        time_init=time(1);
    else
        dt=(time(iacquis)-time(iacquis-1))/1000000;
    end
    
    %a=sum(a(1:4).*2.^[24 16 8 0]);
    %line(1:i,time(1:i));
    if mod(iFrame,100)==0
    %try
    set(t,'String',sprintf('%.2f: %.2f (%.2f Hz) %d',toc,(time(iacquis)-time_init)/1000000,1/dt,n))
    for hl=1:12
       
        set(handle_l(hl),'XData',time(max(1,iacquis-1000):iacquis,1),'YData',ss(max(1,iacquis-1000):iacquis,hl));
    end
    end
    drawnow limitrate;
    %end
    if any(theend~=[255 255 13 10]')
        break
    end
  
end

fclose(s);
ss=ss(1:iacquis,:);
time=time(1:iacquis);
end

function caching(s)
    a=zeros(1,100);
    a=fread(s,50,'uint8');
    for i=51:100
        a(i-4:i-1)
        if all(a(i-4:i-1)==[255 255 13 10]')
            break
        end
        a(i)=fread(s,1,'uint8');
    end
end