function CPA = computeCPA0(OS,TS,time)%OS:owner ship TS:target ship。
%% 基本的CPA计算但是多了一个航向时间。
%将本船和目标船的速度由(速度值+航行角)的极坐标形式转化为(Vx,Vy)的直角坐标形式
CPA=[];
    for i=1:1:length(TS)
        v_own=OS.speed(end,:);
        course_own=OS.Course(end,:);
        pos_own=OS.pos(end,:);
        v_target=TS(i).speed(end,:);
        course_target=TS(i).Course(end,:);
        pos_target=TS(i).pos(end,:);

        V_x1 = v_ownsind(course_own);%WTF:sind是以角度为自变量的sin值，sin是以弧度为单位的，deg2rad将角度转换为弧度
        V_y1 = v_owncosd(course_own);

        V_x2 = v_targetsind(course_target);
        V_y2 = v_targetcosd(course_target);
        %WTF:两船的相对速度
        V_x = V_x1-V_x2;
        V_y = V_y1-V_y2; %WTF:用向量表示以目标船为参照物，本船的相对速度

        pos = pos_target-pos_own;%WTF:两船的位置向量，由本船指向目标船,详细的解释见编程日志

        %WTF:两船的最短距离详细的解释见编程日志
        p_x = [V_y*(V_ypos(1)-V_xpos(2))/(V_x2+V_y2) -V_x*(V_ypos(1)-V_xpos(2))/(V_x2+V_y2)];

        d = norm(p_x-pos,2);
        %% WTF:位置判断算法
        if V_xpos(1)+V_ypos(2)<=0 %说明两船逐渐远离
        %WTF:向量pos=pos_target-pos_own,相对速度向量v=(V_x,V_y),点乘积pos?v=V_xpos(1)+V_ypos(2)，点积夹角(0,pi),
        %WTF:点积<=0,则两船相对位置向量与目标船相对速度向量夹角大于90度，两船正在远离，两船正在远离时，最小距离DCPA即为当前时刻的值
            t = 0;
        else
            t = d/sqrt(V_x2+V_y2);
        end
        if t>time
            t=time;
        end
        %% WTF:距离计算
        pos1=[pos_own(1)+v_own*sind(course_own)*t, pos_own(2)+v_owncosd(course_own)*t];
        pos2=[pos_target(1)+v_targetsind(course_target)*t, pos_target(2)+v_targetcosd(course_target)*t];

        dist=norm(pos1-pos2,2);%WTF:norm求向量的范数，即(x12+x22+x32)(1/2)，即此处的求距离的方程
        CPA = [CPA;pos1,pos2,dist,t]; %函数输出:最近会遇点处OS坐标pos1，TS坐标pos2，DCPA和TCPA
    end
end

