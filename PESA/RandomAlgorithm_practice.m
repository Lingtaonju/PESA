

%%%����������ӵĹ����ǣ���һ�������charger��ʱ��ͬʱҪ�ж���������device�����Ƿ��г�����ֵ��
function [utility,charger_points,Device_EMR] = RandomAlgorithm_practice(region,d,n,Rt,alpha,beta,D,device_points,C1,C2)
    disp('random�㷨������');
    [grids_points,x_grid_num,y_grid_num]=get_charger_points(region,d);  %!!!!!!
    grid_num=x_grid_num*y_grid_num;
    Rt_grid=zeros(1,grid_num); %ÿ�����ӷ����ʼֵ��Ϊ0.
    Device_EMR=zeros(1,size(device_points,1));
    %����ĺ�������ÿ������ķ���һ��charger
    charger_points=zeros(n,2);
    utility=0;
    for charger_num=1:n
        disp(charger_num);
        while 1
%             disp('In while loop:');


            label_put_2=1;
            Rt_grid_copy=Rt_grid;
            point=rand(2,1);
            p_x=point(1)*(region(2)-region(1))+region(1);
            p_y=point(2)*(region(4)-region(3))+region(3);
            %%����������charger֮���ÿ�����ӵķ�����������
            if  p_x>-0.9&&p_x<2.1&&p_y>-0.9&&p_y<2.1
                continue;
            end
            for index_g=1:grid_num
                dis=sqrt((grids_points(index_g,1)-p_x)^2+(grids_points(index_g,2)-p_y)^2);
                if dis<=D
                    Rt_grid_copy(index_g)=Rt_grid_copy(index_g)+C2*alpha/(beta+dis)^2;
                end
                if Rt_grid_copy(index_g)>=Rt %�˴λ�����Ч���˳�ѭ����
                    label_put_2=0;
                    break;
                end
            end
            if ~label_put_2
                continue;
            end
            
            
            

            %��������еĸ����ڲ�����up_times���¾�û�г����Ļ���Ҫ����һ��ÿ�������µķ���ǿ���Լ��ܵĳ��Ч��
            charger_points(charger_num,1)=p_x;
            charger_points(charger_num,2)=p_y;
            Rt_grid=Rt_grid_copy; %����һ��ÿ�������µķ���ǿ��
            for index_d=1:size(device_points,1)
                dis_=sqrt((device_points(index_d,1)-p_x)^2+(device_points(index_d,2)-p_y)^2);
                if dis_<= D
                    utility=utility+C1*alpha/(beta+dis_)^2;
                    Device_EMR(index_d)=Device_EMR(index_d)+C2*alpha/(dis_+beta)^2;
                end
            end
            break;
        end
    end
    disp('charger���������յ�charger�ĸ����ǣ�');
end

