################################################################
##########################第五题 综合编程#########################
# 利用数据结构课所学的任意一种排序方式，将数据区的10个数字按从小到大排序，并输出显示。
# 要求程序的第一行注释里写明是采用什么排序方式，如冒泡排序。
################################################################

# 冒泡排序
# s10	数组入口地址
# s11	数组结束地址

# t0	工具人
# t1	外部循环下标最大值
# t2	内部循环下标最大值

# a1	交换数1地址
# a2	交换数2地址
# a3	交换数1
# a4	交换数2
# a5	打印数组元素地址

# s1	外部循环下标
# s2	内部循环下标
################数据段###################
.data
# 数据定义
array:      .word   -15,1024,12,60,19,26,-18,19,100,86 # 需要进行排序的数组
arrayLen:   .word   10  # 数组长度
# 输出信息
startMsg:   .string "从小到大冒泡排序：-15,1024,12,60,19,26,-18,19,100,86"
endMsg:     .string "\n排序好后的数组为："

################代码段###################
.text
main:
    # 输出提示信息startMsg
    la a0,startMsg
    li a7,4
    ecall
    # 输出提示信息endMsg
    la a0,endMsg
    li a7,4
    ecall
    # 初始化寄存器，把数组放进去
    la s10, array           # s10   数组入口地址
    lw t0, arrayLen         # t0    temp
    addi t0, t0, -1
    slli t0, t0, 2          # t0    temp*4；因为一个.word 4bit，所以左移2位
    add s11, s10, t0        # s11   数组结束地址；s11=s10+arryLen*4;
    # 初始化内外循环下标
    addi s1, zero, 0        # s1    外部循环下标
    addi s2, zero, 0        # s2    内部循环下标
    lw t0, arrayLen
    addi t1, t0, -2         # t1    外层循环下标的最大值 = arrayLen + -2
    # 进入外层循环
    j extloop               # jump to extloop
    
# 外层循环下标++
addExtPos:
    addi s1, s1, 1          # s1 = s1 + 1
    j extloop               # jump to extloop
    
# 内层循环下标++
addInPos:
    addi s2, s2, 1          # s2 = s2 + 1
    j inloop                # jump to inloop

# 冒泡（交换）两数
swap:
    # a1    交换数1地址
    # a2    交换数2地址
    # a3    交换数1
    # a4    交换数2
    sw a4, (a1)             # a4 = *a1；交换数2放入数1地址
    sw a3, (a2)             # a3 = *a2；交换数1放入数2地址
    j addInPos              # jump to addInPos

# 外层循环
extloop:
    bge s1, t1, initprint   # if s1 >= t1 then initprint
    j initIn                # jump to initIn

# 初始化内层循环
initIn:
    # s1    外部循环下标
    # s2    内部循环下标
    sub t2, t1, s1          # t2 = t1 - s1；内层循环的最大值
    addi s2, zero, 0
    j inloop                # jump to inloop

# 内层循环
inloop:
    # a1    交换数1地址（内层循环下标所指）
    # a2    交换数2地址（内层循环下标+1所指）
    # a3    交换数1
    # a4    交换数2
    # t0    工具人（temp）
    # s2    内部循环下标
    # s10   数组入口地址

    bgt s2, t2, addExtPos   # if s2 > t2 then addExtPos；内层循环执行完毕
    # a1 = 数组首地址 + 4*内循环下标
    slli t0, s2, 2          # t0 = 4*内循环下标s2
    add a1, s10, t0         # a1 = s10 + t0
    lw a3, (a1)             # a3 = *a1

    # a2 = a1 + 4
    addi a2, a1, 4          # a2 = a1 + 4
    lw a4, (a2)             # a4 = *a2

    # 判断是否需要冒泡
    bgt a3, a4, swap        # if a1 > a2 then swap
    # 不需要冒泡直接内层循环下标++
    j addInPos              # jump to addInPos

# 初始化数组打印
initprint:
    # s10   数组入口地址
    mv a5, s10              # a5 = s10；（a5此时为数组首地址）
    j printloop             # jump to printloop

# 数组打印循环
printloop:
    # a5    打印数组元素地址
    # s11   数组结束地址
    lw a0, (a5)             # a0 = *a5
    li a7, 1                # 系统调用功能1，输出整数
    ecall                   # 系统调用

    sub t0, s11, a5         # t0 = s11 - a5，地址相减 = 剩余元素个数
    beqz t0, exit           # 剩余元素个数t0 = 0，打印完了，下班
    addi a5, a5, 4          # 没打印完，地址后移4bit打印下一个元素~
    
    addi a0, zero, 44       # ascii 44 = ','   打印个，分隔
    li a7, 11               # 系统调用功能11，输出ascii字符 
    ecall                   # 系统调用
    j printloop             # jump to printloop

# 下班~（退出程序）
exit:
    li a7, 10               # ...终于下班了
    ecall