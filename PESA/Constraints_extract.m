% author:Lingtao Kong
% 2014.7.14
% first version
% ��������������ÿһ�������Լ�����������ص���һ��k*k��Լ������aij����k*1��bi������k�����з������Ŀ�ͣ�
% input: 
% region�� ����������
% d: ���л��ֵĳ��ȵ�λ
% D: charger����Ч������
% alpha��beta�ֱ��ǳ�����
% x_grid_num ��x�᷽���ϵĸ�����
% y_grid_num ��y�᷽���ϵĸ�����
% charger_points ��¼���з����м�λ�õ�����
function [charger_points,constraints,bi]=Constraints_extract(region,d,D,alpha,beta,Rt,C2,bool1_2)
     format long;
     if bool1_2==1  %%ע�������������䡣
        region=region+[-D D -D D];
     end
     [charger_points,x_grid_num,y_grid_num]=get_charger_points(region,d);
     k=y_grid_num*x_grid_num;
     constraints=eye(k)*(C2*alpha/(beta^2)); %���Խ����ϵ�d=0;
     %��sum(xi)<n����
     bi=ones(k,1)*Rt;
     effective_len=(D+2*sqrt(2)*d)^2;  %�������ʵ�������ж��Ƿ����Ӱ�����Ч���롣
     effective_num=floor(D/d+2*sqrt(2)); %��������жϴ�ֱ��ˮƽ�����Ϸ���ĸ�����
     for index=1:k
         if rem(index,x_grid_num)==0
             y_index=index/x_grid_num-1;
         else
              y_index=floor(index/x_grid_num);  %y��(��ֱ���ϵľ������꣬��������y_index��Ԫ�أ�����y_index�Ǵ�0��ʼ
         end
         x_index=index-y_index*x_grid_num-1; %x��(ˮƽ)�����ϵ�λ�ã������λ�õ������x_index��Ԫ�أ�x_indexҲ�Ǵ�0��ʼ��
         left=min(x_index,effective_num);
         right=min(x_grid_num-x_index-1,effective_num);
         down=min(y_index,effective_num);
         up=min(y_grid_num-y_index-1,effective_num);
         %����ֱ���ĸ������Ͻ���Լ����������ȡ
         %�ȴ����濪ʼ����Ϊ������ڸ��Ӻ�������ڸ��ӿ϶���һ������
         if ~(down==0)
              for i=1:down %�ռ���index��ͬһ���е������Ԫ�ء�
                 constraints(index,index-i*x_grid_num)=C2*alpha/((i-1)*d+beta)^2;
              end
              if ~(left==0)  
                 for l=1:left %�ռ���index��ͬһ���е���ߵ�Ԫ�ء�
                     constraints(index,index-l)=C2*alpha/((l-1)*d+beta)^2;
                 end
                 for i=1:down   %�ռ��������޵�Ԫ�ء�
                     for l=1:left
                         index_now=index-i*x_grid_num-l;
                         dis_judge=(charger_points(index,1)-charger_points(index_now,1))^2+(charger_points(index,2)-charger_points(index_now,2))^2;
                         dis_compute=sqrt((i-1)^2+(l-1)^2)*d;
                         if dis_judge<=effective_len
                             constraints(index,index_now)=C2*alpha/(dis_compute+beta)^2;
                         end 
                     end
                 end
              end
              if ~(right==0) %��ʱ�ռ��������޵�Ԫ��
                 for r=1:right
                     constraints(index,index+r)=C2*alpha/((r-1)*d+beta)^2;
                 end
                 for i=1:down
                     for r=1:right
                         index_now=index-i*x_grid_num+r;
                         dis_judge=(charger_points(index,1)-charger_points(index_now,1))^2+(charger_points(index,2)-charger_points(index_now,2))^2;
                         dis_compute=sqrt((i-1)^2+(r-1)^2)*d;
                         if dis_judge<=effective_len
                             constraints(index,index_now)=C2*alpha/(dis_compute+beta)^2;
                         end 
                     end
                 end
              end
         end
         if ~(up==0) %�ԳƵ��ϰ벿��
              for u=1:up
                 constraints(index,index+u*x_grid_num)=C2*alpha/((u-1)*d+beta)^2;
              end
              if ~(left==0)  %��ʱ�ռ��ڶ����޵�Ԫ��
                 for l=1:left
                     constraints(index,index-l)=C2*alpha/((l-1)*d+beta)^2;
                 end
                 for u=1:up
                     for l=1:left
                         index_now=index+u*x_grid_num-l;
                         dis_judge=(charger_points(index,1)-charger_points(index_now,1))^2+(charger_points(index,2)-charger_points(index_now,2))^2;
                         dis_compute=sqrt((u-1)^2+(l-1)^2)*d;
                         if dis_judge<=effective_len
                             constraints(index,index_now)=C2*alpha/(dis_compute+beta)^2;
                         end 
                     end
                 end
              end
              if ~(right==0) %��ʱ�ռ���һ���޵�Ԫ��
                 for r=1:right
                     constraints(index,index+r)=C2*alpha/((r-1)*d+beta)^2;
                 end
                 for u=1:up
                     for r=1:right
                         index_now=index+u*x_grid_num+r;
                         dis_judge=(charger_points(index,1)-charger_points(index_now,1))^2+(charger_points(index,2)-charger_points(index_now,2))^2;
                         dis_compute=sqrt((u-1)^2+(r-1)^2)*d;
                         if dis_judge<=effective_len
                             constraints(index,index_now)=C2*alpha/(dis_compute+beta)^2;
                         end 
                     end
                 end
              end
              
         end
     end
     %%�Ƚ���trival�������
end