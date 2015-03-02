%
% ���ã�
% 1.��������չD��ͨ��get_charger_points��÷�������ꡣ
% 2.������Щ����������Щdevices��
% 3.����ÿһ��С�������Щdevices�ĳ��Ч��cj�����ص�ֵk*1����������
function[pi_charger_utility]=GetUtility(charger_points,region,D,device_points,d,alpha,beta,C1,bool1_2)

    if bool1_2==1
       region=region+[-D D -D D];%����������D
    end
   
    devices_in_region=select_deivices(device_points,region);%�����������豸�������ά���飬n*2
    %charger_points,���������г���������꣬Ҳ����ÿ�������м�λ�õ����꣬k*2������
    pi_charger_utility=count_pi(charger_points,devices_in_region,D,alpha,beta,C1); %ÿ�����Ӳ����ĳ��Ч�ܣ�k*1��������
    
    %
    %select_deivices�����������ĳ�������������device������
    %
    function devices_in_region=select_deivices(device_points,region)
        devices_in_=zeros(size(device_points,1),2);
        num=0;
        for i_=1:size(device_points,1)
            if device_points(i_,1)>region(1) && device_points(i_,1)<region(2)
                if device_points(i_,2)>region(3) && device_points(i_,2)<region(4)
                    num=num+1;
                    devices_in_(num,:)=device_points(i_,:);
                end
            end
        end
        if num==0
            devices_in_region=[];
        else
             devices_in_region=devices_in_(1:num,:);
        end
   end
    %
    %���� dividing_grids������ý�����ʹ��d���л���֮�����и��ӵ�����,����k*2������
    %

    %���溯�����ڼ���ÿ�������С�����ڵĳ��Ч��p,����k*1��������
    function p=count_pi(charger_points,devices_points,D,alpha,beta,C1)
        p=zeros(1,size(charger_points,1)); %%�޸Ĺ�һ�Ρ����Ŀ�������������
        if ~isempty(devices_points)
            for charger_i=1:size(charger_points,1)
                for devices_i=1:size(devices_points,1)
                    dis=sqrt((charger_points(charger_i,1)-devices_points(devices_i,1))^2+(charger_points(charger_i,2)-devices_points(devices_i,2))^2);
                    if dis<=D
                        p(charger_i)= p(charger_i)+C1*alpha/(beta+dis)^2;
                    end
                end
            end   
        end
    end
    %�������ÿ��Լ������ Ŀ���ǵõ�k*k��Լ��������
end




