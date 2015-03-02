
function [x,y] = TriangleAlgorithm_insight(region,d,Rt,alpha,beta,D,device_points,C2,error,charger_num)
%UNTITLED6 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    [grids_points,x_grid_num,y_grid_num]=get_charger_points(region,d);
    grid_num=x_grid_num*y_grid_num;
    %ÿ�����ӷ����ʼֵ��Ϊ0.
    %����ĺ�������ÿ������ķ���һ��charger
    utility=0;
    x=region(2);
    y=region(4);
    r3=sqrt(3);
    num_n=0;
    Rt_grid=[];
    times=0;
    %%%%�����ǵõ�����ʹ����������n��side-length��
    side_left=floor(sqrt(2*x*y/(r3*charger_num)));  %%%%%%%%%%%%����������滹Ҫ���¿���һ��
    num_n=getGridnum(side_left,x,y);
    while num_n<charger_num
        side_left=side_left/2;
        num_n=getGridnum(side_left,x,y);
    end
    %���濪ʼ������㷨
    side_right=min(x,2*r3*y);
    while (side_right-side_left)>error
        times=times+1;
        disp('times:');
        disp(times);
        disp('side_right-side_left:');
        disp(side_right-side_left);
        Rt_grid=zeros(1,grid_num);
        side_middle=(side_left+side_right)/2;
        Rt_over_lable=0;
        [num_n,points_coordinate]= getGridCoordinate(side_middle,x,y);
        %%%�������Ǵӵ�һ��charger��λ�ÿ�ʼ��������λ�õ�chargerʹ��ĳ��λ�õ�RtΥ���ţͣң���ô������side_l
        if num_n>charger_num
            disp('num_n:')
            disp(num_n);
            dele_num=num_n-charger_num;
            for index_de=1:dele_num
                dele_p=floor(rand(1)*(num_n-(index_de-1)));%%this is has been changed
                if dele_p==0
                    dele_p=dele_p+1;
                end
                points_coordinate(dele_p,:)=[];
            end
            num_n=charger_num;
        end
        for charger_index=1:num_n
           % point=floor(charger_index/x_side_num)
           for index_g=1:grid_num
               dis=sqrt((points_coordinate(charger_index,1)-grids_points(index_g,1))^2+(points_coordinate(charger_index,2)-grids_points(index_g,2))^2);
                if dis<=D
                    Rt_grid(index_g)=Rt_grid(index_g)+C2*alpha/(beta+dis)^2;
                end
                if Rt_grid(index_g)>=Rt %����Υ��EMR���˴λ�����Ч���˳�ѭ����
                    Rt_over_lable=1;
                    break;
                end
           end
          
          if Rt_over_lable   %���Υ��
             break;
          end
          
        end
        if Rt_over_lable  
           side_left=side_middle;
        else % %�����û��Υ������Сd
            side_right=side_middle;
        end
    end
    [num_n,points_coordinate]= getGridCoordinate(side_right,x,y);  %%�Ҳ����ȷ������EMR
         if num_n>charger_num
            dele_num=num_n-charger_num;
            for index_de=1:dele_num
                dele_p=floor(rand(1)*(num_n-(index_de-1)));%%this is has been changed
                if dele_p==0
                    dele_p=dele_p+1;
                end
                points_coordinate(dele_p,:)=[];
            end
            num_n=charger_num;
         end
        %%%%here has been the result
        
        
        
        
        
        
        %%%�����Ȳ�����
%     for charger_index=1:num_n
%        for index_d=1:size(device_points,1)
%             dis_=sqrt((device_points(index_d,1)-points_coordinate(charger_index,1))^2+(device_points(index_d,2)-points_coordinate(charger_index,1))^2);
%             if dis_<=D
%                utility=utility+C1*alpha/(beta+dis_)^2;
%             end
%        end
%     end
    [x,y]=Insight_get_value(device_points,points_coordinate,D);
    
    %%getGridnum�������һ��������ݲ�����õ�ĸ�����
    function [n_num,x_num_even,y_num]=getGridnum(side_l,x,y)
        x_num_even=floor(x/side_l)+1; %%ż��0....
        x_num_odd=floor(x/side_l); %%����1,...
        y_num=floor((y/(sqrt(3)*side_l))*2); %%y�ϵĸ���
        n_num=0;
        for index_y=0:y_num
            if rem(index_y,2)==0
                n_num=n_num+x_num_even;
            else
                 n_num=n_num+x_num_odd;
            end
        end
    end
    function[n_num,points_coordinate]= getGridCoordinate(side_l,x,y)
        [n_num,x_num_even,y_num]=getGridnum(side_l,x,y);    
        points_coordinate=zeros(n_num,2);
        index_num=0;
        for index_y=0:y_num
            if rem(index_y,2)==0             
                for index_x=1:x_num_even
                    points_coordinate(index_num+index_x,1)=(index_x-1)*side_l;
                    points_coordinate(index_num+index_x,2)=index_y*sqrt(3)*side_l/2;
                end
                index_num=index_num+x_num_even;
            else
                for index_x=1:x_num_even-1
                    points_coordinate(index_num+index_x,1)=(index_x-1/2)*side_l;
                    points_coordinate(index_num+index_x,2)=index_y*sqrt(3)*side_l/2;
                end
                index_num=index_num+x_num_even-1;
            end
        end
    end
end

