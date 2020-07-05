function snake
   axis equal   %设置x,y刻度相同
   axis([0.5, 20.5, 0.5, 20.5] )  %坐标轴范围
   set(gca,'xtick',[],'ytick',[],'xcolor','w','ycolor','w') %设置坐标轴刻度范围与颜色
   set(gca,'color','g') %背景颜色设置为绿色
   hold on %每次更新图像保持原有图像
   Head = [7,7] ;%蛇头初始位置
   Direct = [1,0]; %蛇头初始方向
   Body = [7,7;6,7;5,7] ;%蛇身初始位置数组
   Length=3; %蛇的初始长度
   food = [12,14]; %食物的初始位置
   obstacle = randi(20,[3,2]);
   Snake = scatter (gca,Body(:,1),Body(:,2),150,'ro','filled');%绘制蛇身为红色实心圆
   Food = scatter(gca,food(1),food(2),150,'bh','filled');%绘制食物为蓝色六角形
   Obstacle = scatter(gca,obstacle(:,1),obstacle(:,2),200,'ro');%绘制障碍物
   set(gcf, 'KeyPressFcn', @key)  %读入用户键盘信息
   fps=5 ;%设置帧数，即蛇的移动速度
   Gaming=timer('ExecutionMode','FixedRate','Period',1/fps,'TimerFcn',@game);%通过定时器完成图像更新，调用game函数实现游戏
   start(Gaming) %启动定时器，开始游戏
   h1=text(20.5,20.5,'当前分数：');%显示游戏开始时的分数
   h2=text(20.5,19.5,'0');
   
   function game(~,~)  %实现蛇的移动
      Head = Head + Direct; %实现蛇头的移动
      Body = [Head;Body];%蛇身移动第一步
      while length(Body)>Length 
           Body(end,:)=[];  %将剩余的蛇尾变为空的
      end
      if intersect(Body(2 : end, : ), Head, 'rows') %判断蛇头是否撞到自己的身体，蛇头与蛇身数组交集非空则为撞上
        a='最后分数：';%显示最后分数
        b=num2str(Length-3);%将分数转化为字符串显示
        c=[a,b];
        Button1 = questdlg(c,'您撞到了自己','重新开始','关闭游戏', '关闭游戏');%弹出选项对话框，失败之后选择下一步
        if Button1 == '重新开始'
            clf;%清屏
            snake();%重新开始
        else
            close;%关闭游戏
        end
      end      
      if ismember(Head,obstacle,'rows')
        a='最后分数：';%显示最后分数
        b=num2str(Length-3);%将分数转化为字符串显示
        c=[a,b];
        Button1 = questdlg(c,'您撞到了障碍','重新开始','关闭游戏', '关闭游戏');%弹出选项对话框，失败之后选择下一步
        if Button1 == '重新开始'
            clf;%清屏
            snake();%重新开始
        else
            close;%关闭游戏
        end
      end  
    if isequal(Head, food)  %判断是否吃到食物，若蛇头坐标等于食物坐标则为吃到食物
      Length = Length + 1; %蛇变长                  
      food = randi(20, [1, 2]); %随机生成数值在1-20，1*2的矩阵作为新的食物坐标
      obstacle = randi(20,[3,2]);
      while any(ismember(Body, food, 'rows')) %如果随机生成的食物坐标在蛇身上则重新随机生成食物坐标
          food = randi(20, [1, 2]);
      end
      while any(ismember(Body, obstacle, 'rows')) %如果随机生成的障碍物坐标在蛇身上则重新随机生成
          obstacle = randi(20,[3,2]);
      end
      while any(ismember(food, obstacle, 'rows'))%随机生成的障碍物坐标与食物重合则重新随机生成
           obstacle = randi(20,[3,2]);
      end
          set(h1,'visible','off')   
          set(h2,'visible','off')   %将上一分数显示清除
          h1=text(20.5,20.5,'当前分数：');
          h2=text(20.5,19.5,num2str(Length-3));  %显示当前分数
    end    
    if (Head(1, 1)>20)||(Head(1, 1)<1)||(Head(1, 2)>20)||(Head(1, 2)<1) %判断是否撞到墙壁
        a='最后分数：';
        b=num2str(Length-3);
        c=[a,b];
        Button2 = questdlg(c,'您撞到了墙壁','重新开始','关闭游戏', '关闭游戏');%与之前对话框类似
        if Button2 == '重新开始'
            clf;
            snake();
        else
            close;
        end
    end
    set(Food, 'XData', food(1),  'YData', food(2));  %重新绘制食物
    set(Snake, 'XData', Body( : , 1), 'YData', Body( : , 2));%重新绘制蛇体
    set(Obstacle,'XData', obstacle( : , 1), 'YData', obstacle( : , 2));%重新绘制障碍物
  end

   function key(~,event) %判断用户操纵的方向      
    switch event.Key            
      case 'uparrow'
        direct = [0, 1];
      case 'downarrow'
        direct = [0, -1];
      case 'leftarrow'
        direct = [-1, 0];
      case 'rightarrow'
        direct = [1, 0];
      case 'space'  %空格使游戏暂停
        stop(Gaming); 
        direct = Direct;
        a='当前分数：';
        b=num2str(Length-3);
        c=[a,b];
        Button3 = questdlg(c ,'游戏暂停 ', '重新开始', '关闭游戏', '继续游戏', '关闭游戏');%暂停对话框
        if Button3 == '重新开始'
            clf;
            snake();
        elseif Button3 == '关闭游戏'
            close;
        else
           start(Gaming);  %继续游戏启动定时器
        end   
      otherwise
        direct = nan ; %其它按键无意义
    end
    if any(Direct + direct) %蛇不能180度转弯 
      Direct = direct;
    end
  end
end