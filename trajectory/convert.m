% Convert the underlying data format of trajectories to a new type
%








function this=convert(this,newtype)

for k=1:numel(this)
  type=this(k).type;
  data=this(k).data;

  switch( type )
    case 'analytic'
      newtype = type;  
    case 'txyz'
      switch( newtype )
        case 'txyz'
          % do nothing
        case 'tlolah'
          data(2:end,:)=ecef2lolah(data(2:end,:));
        otherwise
          error('unhandled conversion');
      end
      
    case 'tlolah'
      switch( newtype )
        case 'tlolah'
          % do nothing
        case 'txyz'
          data(2:end,:)=lolah2ecef(data(2:end,:));
        case 'empty'
          data=[];
        otherwise
          error('unhandled conversion');
      end
      
    case 'geko'
      switch( newtype )
        case 'tlolah'
          C=textscan(data,'%*s%*s%f%f%*s%*s%*s%*s%*s%f%*s%s%s%*[^\n]','Delimiter',',','Headerlines',2);
          if(C{4}{1}(1)=='2')
            Cdate=C{4};
          else
            Cdate=C{5};
          end
          t=86400*rem(datenum(cat(1,Cdate{:}),'yyyy/mm/dd-HH:MM:SS'),1);
          lo=C{2};
          la=C{1};
          h=C{3};
          data=[t,lo,la,h]';
        
        case 'txyz'
          txyz=convert(convert(trajectory(type,data),'tlolah'),'txyz');
          data=txyz.data;
          
        otherwise
          error('unhandled conversion');
      end
          
    case 'gotcha'
      switch( newtype )
        case 'gotcha'
          % do nothing
        case 'tlolah'
          C=textscan(data,'%*s%s%s%s%*f%*f%f%*[^\n]','Delimiter',',','Headerlines',1);

          trep=C{1};
          lorep=C{3};
          larep=C{2};
          h=C{4};

          t=86400*rem(datenum(cat(1,trep),'HH:MM:SS'),1);

          N=numel(lorep);
          lo=zeros(N,1);
          la=zeros(N,1);
          for n=1:N
            s=lorep{n};
            if(s(1)=='-')
              s=[s(1:3),'-',s(5:6),'/60-',s(8:end),'/3600'];
            else
              s=[s(1:2),'+',s(4:5),'/60+',s(7:end),'/3600'];        
            end
            lo(n)=eval(s);
            s=larep{n};
            if(s(1)=='-')
              s=[s(1:3),'-',s(5:6),'/60-',s(8:end),'/3600'];
            else
              s=[s(1:2),'+',s(4:5),'/60+',s(7:end),'/3600'];        
            end
            la(n)=eval(s);
          end
            
          data=[t,lo,la,h]';
 
        case 'txyz'
          txyz=convert(convert(trajectory(type,data),'tlolah'),'txyz');
          data=txyz.data;
           
        otherwise
          error('unhandled conversion');
      end
          
    case 'empty'
      % do nothing
    otherwise
      error('unhandled exception');
  end

  this(k).type=newtype;
  this(k).data=data;
end

return;
