function snake
   axis equal   %����x,y�̶���ͬ
   axis([0.5, 20.5, 0.5, 20.5] )  %�����᷶Χ
   set(gca,'xtick',[],'ytick',[],'xcolor','w','ycolor','w') %����������̶ȷ�Χ����ɫ
   set(gca,'color','g') %������ɫ����Ϊ��ɫ
   hold on %ÿ�θ���ͼ�񱣳�ԭ��ͼ��
   Head = [7,7] ;%��ͷ��ʼλ��
   Direct = [1,0]; %��ͷ��ʼ����
   Body = [7,7;6,7;5,7] ;%�����ʼλ������
   Length=3; %�ߵĳ�ʼ����
   food = [12,14]; %ʳ��ĳ�ʼλ��
   obstacle = randi(20,[3,2]);
   Snake = scatter (gca,Body(:,1),Body(:,2),150,'ro','filled');%��������Ϊ��ɫʵ��Բ
   Food = scatter(gca,food(1),food(2),150,'bh','filled');%����ʳ��Ϊ��ɫ������
   Obstacle = scatter(gca,obstacle(:,1),obstacle(:,2),200,'ro');%�����ϰ���
   set(gcf, 'KeyPressFcn', @key)  %�����û�������Ϣ
   fps=5 ;%����֡�������ߵ��ƶ��ٶ�
   Gaming=timer('ExecutionMode','FixedRate','Period',1/fps,'TimerFcn',@game);%ͨ����ʱ�����ͼ����£�����game����ʵ����Ϸ
   start(Gaming) %������ʱ������ʼ��Ϸ
   h1=text(20.5,20.5,'��ǰ������');%��ʾ��Ϸ��ʼʱ�ķ���
   h2=text(20.5,19.5,'0');
   
   function game(~,~)  %ʵ���ߵ��ƶ�
      Head = Head + Direct; %ʵ����ͷ���ƶ�
      Body = [Head;Body];%�����ƶ���һ��
      while length(Body)>Length 
           Body(end,:)=[];  %��ʣ�����β��Ϊ�յ�
      end
      if intersect(Body(2 : end, : ), Head, 'rows') %�ж���ͷ�Ƿ�ײ���Լ������壬��ͷ���������齻���ǿ���Ϊײ��
        a='��������';%��ʾ������
        b=num2str(Length-3);%������ת��Ϊ�ַ�����ʾ
        c=[a,b];
        Button1 = questdlg(c,'��ײ�����Լ�','���¿�ʼ','�ر���Ϸ', '�ر���Ϸ');%����ѡ��Ի���ʧ��֮��ѡ����һ��
        if Button1 == '���¿�ʼ'
            clf;%����
            snake();%���¿�ʼ
        else
            close;%�ر���Ϸ
        end
      end      
      if ismember(Head,obstacle,'rows')
        a='��������';%��ʾ������
        b=num2str(Length-3);%������ת��Ϊ�ַ�����ʾ
        c=[a,b];
        Button1 = questdlg(c,'��ײ�����ϰ�','���¿�ʼ','�ر���Ϸ', '�ر���Ϸ');%����ѡ��Ի���ʧ��֮��ѡ����һ��
        if Button1 == '���¿�ʼ'
            clf;%����
            snake();%���¿�ʼ
        else
            close;%�ر���Ϸ
        end
      end  
    if isequal(Head, food)  %�ж��Ƿ�Ե�ʳ�����ͷ�������ʳ��������Ϊ�Ե�ʳ��
      Length = Length + 1; %�߱䳤                  
      food = randi(20, [1, 2]); %���������ֵ��1-20��1*2�ľ�����Ϊ�µ�ʳ������
      obstacle = randi(20,[3,2]);
      while any(ismember(Body, food, 'rows')) %���������ɵ�ʳ���������������������������ʳ������
          food = randi(20, [1, 2]);
      end
      while any(ismember(Body, obstacle, 'rows')) %���������ɵ��ϰ����������������������������
          obstacle = randi(20,[3,2]);
      end
      while any(ismember(food, obstacle, 'rows'))%������ɵ��ϰ���������ʳ���غ��������������
           obstacle = randi(20,[3,2]);
      end
          set(h1,'visible','off')   
          set(h2,'visible','off')   %����һ������ʾ���
          h1=text(20.5,20.5,'��ǰ������');
          h2=text(20.5,19.5,num2str(Length-3));  %��ʾ��ǰ����
    end    
    if (Head(1, 1)>20)||(Head(1, 1)<1)||(Head(1, 2)>20)||(Head(1, 2)<1) %�ж��Ƿ�ײ��ǽ��
        a='��������';
        b=num2str(Length-3);
        c=[a,b];
        Button2 = questdlg(c,'��ײ����ǽ��','���¿�ʼ','�ر���Ϸ', '�ر���Ϸ');%��֮ǰ�Ի�������
        if Button2 == '���¿�ʼ'
            clf;
            snake();
        else
            close;
        end
    end
    set(Food, 'XData', food(1),  'YData', food(2));  %���»���ʳ��
    set(Snake, 'XData', Body( : , 1), 'YData', Body( : , 2));%���»�������
    set(Obstacle,'XData', obstacle( : , 1), 'YData', obstacle( : , 2));%���»����ϰ���
  end

   function key(~,event) %�ж��û����ݵķ���      
    switch event.Key            
      case 'uparrow'
        direct = [0, 1];
      case 'downarrow'
        direct = [0, -1];
      case 'leftarrow'
        direct = [-1, 0];
      case 'rightarrow'
        direct = [1, 0];
      case 'space'  %�ո�ʹ��Ϸ��ͣ
        stop(Gaming); 
        direct = Direct;
        a='��ǰ������';
        b=num2str(Length-3);
        c=[a,b];
        Button3 = questdlg(c ,'��Ϸ��ͣ ', '���¿�ʼ', '�ر���Ϸ', '������Ϸ', '�ر���Ϸ');%��ͣ�Ի���
        if Button3 == '���¿�ʼ'
            clf;
            snake();
        elseif Button3 == '�ر���Ϸ'
            close;
        else
           start(Gaming);  %������Ϸ������ʱ��
        end   
      otherwise
        direct = nan ; %��������������
    end
    if any(Direct + direct) %�߲���180��ת�� 
      Direct = direct;
    end
  end
end