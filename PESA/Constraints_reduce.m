function [constraints_remained,bi_remained] = Constraints_reduce(constraints,bi)
   
                        format long;
                        %��ȥ����trival��
                        bi_left=sum(constraints,2);
                        xi_num=size(constraints,2);
                        lu=zeros(1,xi_num);
                        ub=ones(1,xi_num);
                        No_trivial_lines=find((bi_left-bi)>0);
                        if isempty(No_trivial_lines)
                            constraints_remained=constraints(size(constraints,1),:);
                            bi_remained=bi(size(constraints,1),:);
                            return;   
                        end
                        constraints_remained=zeros(size(No_trivial_lines,1),xi_num);
                        bi_remained=zeros(size(No_trivial_lines,1),1);
                        for index=1:size(No_trivial_lines,1)
                            line=No_trivial_lines(index,1);
                            constraints_remained(index,:)=constraints(line,:);
                            bi_remained(index,:)=bi(line,:);
                        end
%                         %��������ȥ������һЩԼ���
%                         %�����Ƕ�ÿһ�У�ʹ�������н���LP�õ����Ž⣬���ұ߽��бȽϣ�����ұ�ֵ��Ļ���ɾ����
%                         %���������һ��������Ҫע����ǣ�matlab�Դ���linprog��Ŀ����������С��������Ҫ�Ƚ�Ŀ����ȡ����Ȼ���z��ȡ�����ɵõ�ֵ��
                        total_line=size(constraints_remained,1);

                        total_del=0;
                      
                        for index=1:total_line-1 %%��֤���һ������������Ϊ�����ܾ�ֻʣһ��  
            
                            index_line=index-total_del;
                            A=constraints_remained;
                            b=bi_remained;
                            c=-A(index_line,:);   %%%%ע��Ҫȡ��
                            b_right=b(index_line);
                            A(index_line,:)=[];
                            b(index_line,:)=[];
                            Aeq=[];
                            beq=[];
                            [x,z]=linprog(c,A,b,Aeq,beq,lu,ub); 
%                             zi(index)=z;
                            if (-z)<=b_right %��ȡ��һ�Ρ�
                                constraints_remained(index_line,:)=[];
                                bi_remained(index_line,:)=[];
                                total_del=total_del+1;
                                disp(index);
                            end
                        end
  
end

