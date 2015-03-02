
%��������Ĺ����ǣ�constraints
%1.�Ƚ� constraints��bi����ȡ����
%2.ʹ�ý����㷨���㡣�������������������Utility��
function [Z_max,Xi_max,Device_EMR] = LP_approx_Random(constraints,bi,pi_charger_utility,ep1,device_points,charger_points,charger_num,D,C1,alpha,beta)
%UNTITLED11 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%     epsilon_ap=0.9; %%Ϊ
    epsilon=ep1;
    format long;
    n=size(constraints,2); %charger����
    for i=1:size(constraints,1)
        constraints(i,:)=floor((constraints(i,:)/bi(i))*(n/epsilon))+1;  %%%%�޸ģ����Ǽ�1
    end
    bi=ones(size(bi,1),1)*(floor(n/epsilon)); %%�޸ģ�ones(sizes(bi,1)) checked 7.22
      m=size(bi,1);%Ҳ��Լ�������ĸ�����
%     %k=min(n,ceil(m*(1-epsilon_ap)/epsilon_ap));
    k=1;
    N=ones(1,n); % N=[1 2 3 4...n;]
    for i=1:n
        N(i)=i;
    end
    Z_max=0; %ʹ�ô˷������������ֵ
    Xi_max=zeros(m,1);
    Device_EMR=zeros(1,size(device_points,1));
    error_lp=0;
    for elem_num=1:k
        disp('S��Ԫ�صĸ����ǣ�');
        disp(elem_num);
        S_set=nchoosek(N,elem_num); %�õ�S��Ԫ��Ϊelem_num�����е����
        for index_Set=1:size(S_set,1) %����ÿһ�������
            disp(index_Set);
            S=S_set(index_Set,:); %S�е�Ԫ��,��Ӧ��X�е�xi��1
            X=ones(n,1)*2; %��ʼֵ��Ϊ2������Ƚ�
            aij=constraints;
          %  Xi_max=zeros(m,1);
            cj=pi_charger_utility;
            bi_=bi;
            minCj=cj(S(1));
            %��S��Ԫ�أ���Ӧ��X�е�Ԫ�أ���1
            for index_i=1:elem_num
                X(S(index_i))=1;
                minCj=min(minCj,cj(S(index_i)));
            end
            %����Ѱ��Ts�е�Ԫ�أ�����X�ж�Ӧ��Ԫ����0
            Ts=setdiff(N,S);
            index_line=1;
            for t=1:size(Ts,2)
                if cj(Ts(index_line))<=minCj; %%%%��߻��ǳ����ˡ�
                    Ts(index_line)=[];
                else
                    X(Ts(index_line))=0; %��Ts��Ӧ��xi��Ϊ0
                    index_line=index_line+1;
                end
            end
            %�ж�bi(s)=bi-sun(aij)(j����S)�Ƿ����0������Ҫ���е�ֵ������0�ſ���
             label=1;
            for index_m=1:m
                sum_bi=0;
                for index_s_=1:elem_num
                    sum_bi=sum_bi+aij(index_m,S(index_s_));
                end
                if sum_bi>bi_(index_m) %�˳�ѭ�������м���
                    label=0;
                    break;
                end
            end
            if label %����������������������ʱ��LP(s)
                %���x��xi������0,1����Щδ֪�������Ž�

                ZS=0; %����S��Ԫ�ص�cj��ֵ��
                for index_S=1:elem_num   %%%%�����顣ע��S�б���Ĳ���index
                    index=S(index_S);
                    bi_=bi_-aij(:,index);
                    aij(1,index)=-1;   %%%%-1��������ʶ
                    ZS=ZS+cj(index);
                    cj(index)=-1;
                end
                for index_T=1:size(Ts,2)  %%�����顣Ts��index.....���ڵ������bug�ˡ�����������Ϊ�����Ѿ�ɾ�������ˡ�
                    index_t=Ts(index_T);
                    aij(1,index_t)=-1;
                    cj(index_t)=-1;
                end
                %%%%���潫aij��cij��-1����ȥ��
               % [row,key]=find(aij==-1);
               aij_column=1;
              for time=1:size(aij,2)
                   if aij(1,aij_column)==-1
                       aij(:,aij_column)=[];
                   else
                       aij_column=aij_column+1;
                   end
               end
              cj_column=1;
              for time=1:size(cj,2)
                   if cj(cj_column)==-1
                       cj(cj_column)=[];
                   else
                       cj_column=cj_column+1;
                   end
              end
                %���濪ʼ��⣺
              if isempty(cj)
                  continue;
              end
              Aeq=[];
              beq=[];
              lu=zeros(1,size(aij,2));
              ub=ones(1,size(aij,2));
       
              [x,z]=linprog(-cj,aij,bi_,Aeq,beq,lu,ub);  %%�����飺�����ò���z���㷨�ļ��㹫ʽ�ǣ�   
              if ~isempty(find(x>1))||~isempty(find(x<0))
                    error_lp=error_lp+1;
                    continue;
               end
               ceshi_max=z;
               x=floor(x); %�����������ֵ
               Zx=0;
               for index_x=1:size(x,1)
                    Zx=Zx+cj(index_x)*x(index_x);
                end
               if Z_max<=ZS+Zx                  
                    X_2=find(X==2);
                    for index_X2=1:size(X_2,1)
                        X(X_2(index_X2))=x(index_X2);
                    end
                    Xi_max=X;
                    Z_max=ZS+Zx;
               end
            end 
        end
    end
    %     Rt=47.968;
    %%%%���潫��ֵ�ӽ�ȥ
    region=[0 20 0 20];
    d=1;
    C2=1;
    [grids_points,x_grid_num,y_grid_num]=get_charger_points(region,d);  %!!!!!!
    grid_num=x_grid_num*y_grid_num;
    Rt_grid=zeros(1,grid_num); %ÿ�����ӷ����ʼֵ��Ϊ0.
    X_1=find(Xi_max==1);
    sum=charger_num-size(X_1,1); 
    if isempty(X_1)
        return;
    end
    Rt=0.8;
    if sum>0
        %line_max=size(charger_points,1); 
        %�õ���ÿ�����ӵ���ֵ��
        for num=1:size(X_1,1)
            index=X_1(num);
            p_x=charger_points(index,1);
            p_y=charger_points(index,2);
            for index_g=1:grid_num
                dis=sqrt((grids_points(index_g,1)-p_x)^2+(grids_points(index_g,2)-p_y)^2);
                if dis<=D
                    Rt_grid(index_g)=Rt_grid(index_g)+C2*alpha/(beta+dis)^2;
                end
            end
        end
        umax=0;
        umax_xi=Xi_max;
        %%%����100�εõ�u_max;
        for get_max_test=1:1000
            disp('�����ǣ�');
            disp(get_max_test);
            Rt_new=Rt_grid;
            u=0;
            drop_test=0;
            random_xi=Xi_max;
            for loop=1:sum
                 zero_line=find(Xi_max==0);
                 loop_time=0;
                 while 1
                     if loop_time>100  %%%����100 �λ�û�з��õĻ����������
                         drop_test=1;
                         break;
                     end
                     Rt_grid_copy=Rt_new;
%                      disp('loop:');
                     label_2=1;
                     rand_value=min(size(zero_line,1),size(charger_points,1));
                     open_line=floor(rand(1)*rand_value);
                     if open_line==0
                         open_line=open_line+1;
                     end
                     x=charger_points(zero_line(open_line),1);
                     y=charger_points(zero_line(open_line),2);
                     for index_g=1:grid_num
                            dis=sqrt((grids_points(index_g,1)-x)^2+(grids_points(index_g,2)-y)^2);
                            if dis<=D
                                Rt_grid_copy(index_g)=Rt_grid_copy(index_g)+C2*alpha/(beta+dis)^2;
                            end
                            if Rt_grid_copy(index_g)>=Rt %�˴λ�����Ч���˳�ѭ����
                                loop_time=loop_time+1;
                                label_2=0;
                                break;
                            end
                     end  
                     if label_2
                         break;
                     end
                 end
                 if drop_test
                     disp('drop');
                     break;
                 end
                 Rt_new=Rt_grid_copy;
                 random_xi(zero_line(open_line))=1;
                 for index_d=1:size(device_points,1)
                    dis_=sqrt((device_points(index_d,1)-x)^2+(device_points(index_d,2)-y)^2);
                    if dis_<= D
                        u=u+C1*alpha/(beta+dis_)^2;
                    end
                 end                
            end
            if umax<u
                umax=u;
                umax_xi=random_xi;
            end
        end
        Z_max=Z_max+umax;
        Xi_max=umax_xi;
    end   
end

    
    
    
    


