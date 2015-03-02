%��������Ĺ���������ʵ�� ����㷨��
%region�������ʽ�ǣ�[0 x 0 y]
% device_points_set�������ʽ�ǣ�[x1 y1; x2 y2;...xn yn];
% C1�����ڼ�����Ч�ʵĲ���
% C2�����ڼ������Ĳ���
function [utility] = RandomAlgorithmUtility(region,d,n,Rt,alpha,beta,D,up_times,device_points,C1,C2)
%UNTITLED5 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%   �Ƚ�����region��d���֣�������е������
    disp('random�㷨������');
    [grids_points,x_grid_num,y_grid_num]=get_charger_points(region,d);  %!!!!!!
    grid_num=x_grid_num*y_grid_num;
    Rt_grid=zeros(1,grid_num); %ÿ�����ӷ����ʼֵ��Ϊ0.
    %����ĺ�������ÿ������ķ���һ��charger
    utility=0;
    for charger_num=1:n
        label_exit=0;
        for times=1:up_times
            Rt_grid_copy=Rt_grid;
            label_Over=0;
            point=rand(2,1);
            p_x=point(1)*region(2);
            p_y=point(2)*region(4);
            %%����������charger֮���ÿ�����ӵķ�����������
            for index_g=1:grid_num
                dis=sqrt((grids_points(index_g,1)-p_x)^2+(grids_points(index_g,2)-p_y)^2);
                if dis<=D
                    Rt_grid_copy(index_g)=Rt_grid_copy(index_g)+C2*alpha/(beta+dis)^2;
                end
                if Rt_grid_copy(index_g)>=Rt %�˴λ�����Ч���˳�ѭ����
                    label_Over=1;
                    break;
                end
            end
            if times==up_times&&label_Over==1
                label_exit=1; 
                break;
            end
            %��������еĸ����ڲ�����up_times���¾�û�г����Ļ���Ҫ����һ��ÿ�������µķ���ǿ���Լ��ܵĳ��Ч��
            if ~label_Over 
                Rt_grid=Rt_grid_copy; %����һ��ÿ�������µķ���ǿ��
                for index_d=1:size(device_points,1)
                    dis_=sqrt((device_points(index_d,1)-p_x)^2+(device_points(index_d,2)-p_y)^2);
                    if dis_<= D
                        utility=utility+C1*alpha/(beta+dis_)^2;
                    end
                end
                break;
            end
        end
        if label_exit
            disp('chargerδ��ȫ���ã����յ�charger�ĸ����ǣ�');
            disp(charger_num);
            break;
        end
    end
    disp('charger���������յ�charger�ĸ����ǣ�');
    disp(charger_num);
end

