% author:Lingtao Kong
% 2014.7.17
% first version
% Input:
% Region,����������Ч��Χ�������ʽ��[x1 x2 y1 y2]
% D����Ч�ĳ��뾶
% d�ǵڶ��λ�������ʱ�ĳ���
% k�ǻ���k-gridʱ��Ĳ���
% charger_num�ǳ����������
% devices_points_set���豸������ļ���
% epsilon�����ڽ��ƵĲ���
% alpha��beat�ǳ��Ч�õĲ���
% Rt�ǳ��������ֵ��
% Output:
% U_output��ʾ�Ĵ��������ĳ��Ч��
% Yk_output,Xk_output��ʾ���õĹرշ�����Y..����Y���ϵ�����
% X_subregion_num��ʾ���ֻ��ַ�����Ӧ��x���ϵĸ�����Y_subregion_num��ʾy���ϵĸ�����
% Charger_allocation,�������ÿ������ķ��������
% Charger_placement, �������ÿ������ķ��÷�����Xi

function [U_output,Yk_output,Xk_output,Charger_allocation,Charger_placement,X_subregion_num,Y_subregion_num]=FinalOutput(Region,D,d,k,charger_num,devices_points_set,ep1,alpha,beta,Rt,C1,C2)
    % ���ѭ����ѭ��ÿһ�ֻ��ֲ���(i,j)���õ���Ӧ�Ļ�����õĲ��ò����Լ����Ч�ʡ�����k*k��
    bool_1=1;%%��FinalOutput2���ֿ���
    bool_2=2;
    U_output=0;
    Yk_output=1;
    Xk_output=1;
    Charger_allocation=[]; %������ķ������
    Charger_placement=[];  %�������ÿһ������Ŀ��ز��ԡ�
    X_subregion_num=0;
    Y_subregion_num=0;
    new_sub_area_location=GridFormation(Region,D,k);  %new_sub_area_location��2��Ԫ�����飬�洢k*k�����򻮷ֱַ��Ӧ�������
    lable_exit=0;
    
     for index_y=1:k %��ֱ������
        for index_x=1:k %ˮƽ������
            
            lable_exit=0;
            disp('index_x�ǣ�');
            disp(index_x);
            region=new_sub_area_location{index_y,index_x};
            utility=zeros(size(region,1)*size(region,2),charger_num); %�洢ĳ�������Ӧ��utility(i,j)
            Xi=cell(size(region,1)*size(region,2),charger_num); %�洢 ĳ�������Ӧ��xi
            
            
            for index_sub_y=1:size(region,1)
                for index_sub_x=1:size(region,2)
                    %����ÿһ�����������ֱ����1-devices_num��charger�����
                    index_k=(index_sub_y-1)*size(region,2)+index_sub_x;
                    sub_region=region{index_sub_y,index_sub_x}; %�õ� [x1 x2 y1 y2]
                    new_region_label=1;
                    [charger_points,constraints,bi]=Constraints_extract(sub_region,d,D,alpha,beta,Rt,C2,bool_1);
                    filename=strcat('.\middle_data\constraints_',num2str(index_k),'.mat');
                    save(filename,'charger_points','constraints','bi');
                    if size(constraints,1)<charger_num
                        lable_exit=1;
                        break;
                       
                    end
                    for n=1:charger_num
                        p=load(filename);
                        charger_points=p.charger_points;
                        constraints=p.constraints;
                        bi=p.bi;
                        c_num=size(constraints,1);
                        constraints(c_num+1,:)=ones(1,c_num);
                        bi(c_num+1)=n/(1-ep1); %%%ע������ĸĶ�
%                       [charger_points,constraints,bi]=Constraints_extract(sub_region,d,D,alpha,beta,Rt,n,C2,ep1);  %%%%�ⲿ�ֳ��򻹿��ԸĽ���
                        [constraints,bi] = Constraints_reduce(constraints,bi);   %%%bug�޸ģ�Ҫ����charger_num���ڸ��ӵ�
                        bbb=size(bi,1);
                        pi_charger_utility=GetUtility(charger_points,sub_region,D,devices_points_set,d,alpha,beta,C1,bool_1);
                        
                disp('Ԫ����:');
                disp(size(constraints,1));
                disp(size(bi,1));
                        
                        
                

                    [z,xi]=LP_approx(constraints,bi,pi_charger_utility,ep1);
                    utility(index_k,n)=z;
                    Xi{index_k,n}=xi;
                    end
                end
                if  lable_exit
                    break;
                    
                end
            end
            %%% �ҵ����ֻ��ֶ�Ӧ���������������U��I������DA_GSC���� Xu
     
            if ~lable_exit
                    [Max_u,Xu]=DA_GSC(utility);
            %�������µĸ����utility��ʱ����и���
                    if U_output<Max_u
                        U_output=Max_u;
                        Yk_output=index_y;
                        Xk_output=index_x;
                        Charger_allocation=Xu;
                        X_subregion_num=size(region,2); 
                        Y_subregion_num=size(region,2);
                        Charger_placement=cell(size(Xu,1),1);
                        for index_Xu=1:size(Xu,1)
                            Charger_placement{index_Xu,1}=Xi{Xu(index_Xu,1),Xu(index_Xu,2)}';
                        end
                    end
            end
        end
    end
end