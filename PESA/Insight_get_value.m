function [x_axis,y_axis] = Insight_get_value(device_points,charger_open_points,D)
%UNTITLED7 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    %�Ȼ��ĳһ��ÿһ��device�ܱߵ�device_number��charger_open_points_number
    device_p=device_points;
    charger_o_p=charger_open_points;
    radius_length=D*D;
    device_number=size(device_points,1);
    charger_number=size(charger_open_points,1);
    index_device_charger_relation=zeros(device_number,3);
    for index_d=1:device_number
        num_device=0;
        for index_d_d=1:device_number
            if (device_p(index_d,1)-device_p(index_d_d,1))^2+(device_p(index_d,2)-device_p(index_d_d,2))^2<radius_length
                num_device=num_device+1;
            end
        end
        num_charger=0;
        for index_c=1:charger_number
            if (device_p(index_d,1)-charger_o_p(index_c,1))^2+(device_p(index_d,2)-charger_o_p(index_c,2))^2<radius_length
                num_charger=num_charger+1;
            end
        end
       index_device_charger_relation(index_d,1)=index_d;
       index_device_charger_relation(index_d,2)=num_device;
       index_device_charger_relation(index_d,3)=num_charger;
    end
    %�ҵ�x���������Ǹ�ֵ
    m=max(index_device_charger_relation,[],1);
    upper=m(2);
    %%%������ƽ���ķ�ʽ�ҵ�y���ϵ�
    x_axis=zeros(1,upper);
    y_axis=zeros(1,upper);
    for u=1:upper
        y_charger=0;
        x_axis(u)=u;
        row=find(index_device_charger_relation(:,2)==u);  %%�õ������кŵļ���
        total_line=size(row,1);
        %�����¼������������û������㣬�Ǹ��ϵ㣺
       if total_line==0
           y_axis(u)=-1;
           continue;
       end
       for l=1:total_line
           line_no=row(l); %�õ��к�
           y_charger=y_charger+ index_device_charger_relation(line_no,3);
       end
       y_axis(u)=y_charger/total_line;
    end
    %%�޳���-1�ĵ�
    del_set=find(y_axis==-1);
    if ~isempty(del_set)
        for del=1:size(del_set)
            x_axis(del_set(del)-(del-1))=[];
            y_axis(del_set(del)-(del-1))=[];
        end
    end
    
end

