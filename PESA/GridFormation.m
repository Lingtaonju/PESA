% author:Lingtao Kong
% 2014.7.14
% first version

% ��������Ĺ��ܣ�������region��D��k���л����γ�k-grid.Ȼ�����Щ����ִ����ͬ�Ĺرղ��ԣ���k*k�֣��洢������Щ�����γɵ��������λ�á�
% Input:
% region�ǳ�����Ч����
% D�ǳ�����Ч���룬
% k��ÿ���������õĸ�����Ŀ
% Output:
% 
% sub_region_num���ܹ����������Ŀ
% location��Ԫ�����飬�洢����֮��ÿ��k-grid������ĵ�ַ��Χ
% distance_sub_area��һ��k-grid����Ŀ�ȷ�Χ��
% new_location:Ԫ�����飬�洢������ִ����ͬ�Ĺرղ���֮������γɵ�ÿ��������ĵ�ַ��Χ
% new_location_sub_area:Ԫ�����飬���ڴ洢ÿ�ֻ��������Ӧ�������λ�ã���ÿһ��Ԫ����Ȼ��һ��Ԫ�����飬�洢���Ǿ���Ļ���
% ��
% sub_area=new_location_sub_area{1,1}�Ƕ�Ӧ(1,1)����֮�������sub_area{1,1}��Ӧ�����������ĵ�һ���������λ��
function new_sub_area_location=GridFormation(region,D,k)
    d=4*D;
    x_grid_num=ceil((region(2)-region(1))/d); % x���ϸ��ӵ�����
    y_grid_num=ceil((region(4)-region(3))/d); %y���ϻ��ֵ��������Ŀ
    x_sub_num=ceil(x_grid_num/k);   %x���ϻ��ֵ��������Ŀ
    y_sub_num=ceil(y_grid_num/k);   %y���ϻ��ֵ��������Ŀ
    new_sub_area_location=cell(k,k);    %�洢����֮�������,��k*k�ֻ��֣����Զ�Ӧ��ôk*k��ԭ�����顣
    location=cell(y_sub_num,x_sub_num); %�洢û�л���֮ǰ��������������ò��Ǻܴ�
    for i=1:y_sub_num
        for j=1:x_sub_num
            location{i,j}=[(j-1)*k*d,j*k*d,(i-1)*k*d,i*k*d]; 
        end
    end
    %����Ĵ����¼��ִ�е�i��(k*k)�ֹرղ���֮���Ӧ��ÿһ�������λ��
    for i=1:k   %%������pay attention to this that i is related to the y-axis ,j is related to the 
        for j=1:k
            if i==1 %!!!!i==1��ʱ���Ǵ�����п�ʼ����
                new_location=cell(y_sub_num,x_sub_num);%������ĸ�������
                if j==1  %��������£������������Ͻ�
                    for new_i=1:y_sub_num
                        for new_j=1:x_sub_num
                            new_location{new_i,new_j}=[location{new_i,new_j}(1,1)+d,location{new_i,new_j}(1,2),location{new_i,new_j}(1,3)+d,location{new_i,new_j}(1,4)];
                        end
                    end
                   % new_sub_area_location{i,j}=new_location;
                elseif j==k %��������£���������������Ͻ�
                     for new_i=1:y_sub_num
                        for new_j=1:x_sub_num
                            new_location{new_i,new_j}=[location{new_i,new_j}(1,1),location{new_i,new_j}(1,2)-d,location{new_i,new_j}(1,3)+d,location{new_i,new_j}(1,4)];
                        end
                     end
                    %new_sub_area_location{i,j}=new_location;
                else %����������£�x�᷽���ϣ��з����ϣ�������һ�������γ�(x_sub_num)*(y_sub_num+1) 
                     new_location=cell(y_sub_num,x_sub_num+1);
                     for new_i=1:y_sub_num
                        for new_j=1:x_sub_num+1
                            if new_j==1 %��һ������
                                new_location{new_i,1}=[0,(j-1)*d,(new_i-1)*k*d+d,new_i*k*d];
                            elseif new_j==x_sub_num+1 %���һ������
                                new_location{new_i,new_j}=[(x_sub_num-1)*k*d+j*d,x_sub_num*k*d,(new_i-1)*k*d+d, new_i*k*d];
                            else %�м�����
                                new_location{new_i,new_j}=[(new_j-2)*k*d+j*d,(new_j-1)*k*d+(j-1)*d,(new_i-1)*k*d+d,new_i*k*d];
                            end
                        end
                     end
                end
            elseif i==k % !!!!i==k��ʱ���Ǵӵڶ��п�ʼ����
                new_location=cell(y_sub_num,x_sub_num);
                if j==1 %���������ԭ��������������µ�������������½�
                    for new_i=1:y_sub_num
                        for new_j=1:x_sub_num
                            new_location{new_i,new_j}=[location{new_i,new_j}(1,1)+d,location{new_i,new_j}(1,2),location{new_i,new_j}(1,3),location{new_i,new_j}(1,4)-d];
                        end
                    end               
               elseif j==k %���������ԭ��������������µ�������������½�
                    for new_i=1:y_sub_num
                        for new_j=1:x_sub_num
                            new_location{new_i,new_j}=[location{new_i,new_j}(1,1),location{new_i,new_j}(1,2)-d,location{new_i,new_j}(1,3),location{new_i,new_j}(1,4)-d];
                        end
                    end  
               else %����������£�x�᷽���ϣ��з����ϣ�������һ�������γ�(y_sub_num)*(x_sub_num+1) 
                    new_location=cell(y_sub_num,x_sub_num+1);
                    for new_i=1:y_sub_num
                        for new_j=1:x_sub_num+1
                            if new_j==1 %��һ������
                                new_location{new_i,1}=[0,(j-1)*d,(new_i-1)*k*d,new_i*k*d-d];
                            elseif new_j==x_sub_num+1 %���һ������
                                new_location{new_i,new_j}=[(x_sub_num-1)*k*d+j*d,x_sub_num*k*d,(new_i-1)*k*d,new_i*k*d-d];
                            else %�м�����
                                new_location{new_i,new_j}=[(new_j-2)*k*d+j*d,(new_j-1)*k*d+(j-1)*d,(new_i-1)*k*d,new_i*k*d-d];
                            end
                        end
                     end
               end
            
            else % !!!!���м俪ʼ����
                if j==1 % ��������������y_sub_num+1)*(x_sub_num)
                     new_location=cell(y_sub_num+1,x_sub_num);
                     for new_i=1:y_sub_num+1
                        for new_j=1:x_sub_num
                            if new_i==1 %��Ӧ����ŵ�����
                                new_location{1,new_j}=[(new_j-1)*k*d+d,new_j*k*d,0,d*(i-1)];
                            elseif new_i==y_sub_num+1 %���һ������
                                new_location{new_i,new_j}=[(new_j-1)*k*d+d,new_j*k*d,(y_sub_num-1)*k*d+i*d,y_sub_num*k*d];
                            else %�м�����
                                new_location{new_i,new_j}=[(new_j-1)*k*d+d,new_j*k*d,(new_i-2)*k*d+i*d,(new_i-1)*k*d+(i-1)*d];
                            end
                        end
                     end
                    
                elseif j==k % ��������������y_sub_num+1)*(x_sub_num)
                     new_location=cell(y_sub_num+1,x_sub_num);
                     for new_i=1:y_sub_num+1
                        for new_j=1:x_sub_num
                            if new_i==1 %��Ӧ����ŵ�����
                                new_location{1,new_j}=[0,new_j*k*d-d,0,d*(i-1)];
                            elseif new_i==y_sub_num+1 %���һ������
                                new_location{new_i,new_j}=[0,new_j*k*d-d,(y_sub_num-1)*k*d+i*d,y_sub_num*k*d];
                            else %�м�����
                                new_location{new_i,new_j}=[0,new_j*k*d-d,(new_i-2)*k*d+i*d,(new_i-1)*k*d+(i-1)*d];
                            end
                        end
                     end
                else   % !!!!���м俪ʼ���֣���Ϊ���������Ѿ������꼫������������������Լ򵥡������(x_sub_num+1)*(y_sub_num+1)��
                
                    new_location=cell(y_sub_num+1,x_sub_num+1);
                    for new_i=1:y_sub_num+1 %�Ե�����
                        for new_j=1:x_sub_num+1 %��������
                            if new_i==1  % new_i==1������µ�����
                               if new_j==1 %��һ������
                                    new_location{1,1}=[0,(j-1)*d,0,(i-1)*d];
                                elseif new_j==x_sub_num+1 %���һ������
                                    new_location{1,new_j}=[d*k*(x_sub_num-1)+j*d,d*k*x_sub_num,0,(i-1)*d];
                                else %�м�����
                                    new_location{new_i,new_j}=[(new_j-2)*k*d+j*d,(new_j-1)*k*d+(j-1)*d,0,(i-1)*d];
                                end

                            elseif new_i==y_sub_num+1 % new_i==y_sub_num+1��Ӧ���������������
                                   if new_j==1 %��new_i,1һ������
                                        new_location{new_i,1}=[0,(j-1)*d,(y_sub_num-1)*k*d+i*d,y_sub_num*k*d];
                                   elseif new_j==x_sub_num+1 %���һ������
                                         new_location{new_i,new_j}=[d*k*(x_sub_num-1)+j*d,d*k*x_sub_num,(y_sub_num-1)*k*d+i*d,y_sub_num*k*d];
                                   else %�м�����
                                        new_location{new_i,new_j}=[d*k*(new_j-2)+j*d,d*k*(new_j-1)+(j-1)*d,(y_sub_num-1)*k*d+i*d,y_sub_num*k*d];
                                   end
                            else % new_i��Ӧ�����м������
                                   if new_j==1 %��new_i,1һ������
                                        new_location{new_i,1}=[0,(j-1)*d,(new_i-2)*k*d+i*d,(new_i-1)*k*d+(i-1)*d];
                                   elseif new_j==x_sub_num+1 %���һ������
                                         new_location{new_i,new_j}=[d*k*(x_sub_num-1)+j*d,d*k*x_sub_num,(new_i-2)*k*d+i*d,(new_i-1)*k*d+(i-1)*d];
                                   else %�м�����
                                        new_location{new_i,new_j}=[d*k*(new_j-2)+j*d,d*k*(new_j-1)+(j-1)*d,(new_i-2)*k*d+i*d,(new_i-1)*k*d+(i-1)*d];
                                   end
                            end     
                        end
                    end
                    
                end
            end
            new_sub_area_location{i,j}=new_location;
        end
    end
end