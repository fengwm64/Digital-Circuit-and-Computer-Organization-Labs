################################################################
##########################第四题 系统调用#########################
# 输出提示信息“请输入姓名：”，从键盘输入本人姓名的字符串；
# 输出提示信息“请输入学号：”，输入本人学号后3位（整数形式）。
# 程序结束后调用exit功能退出。
################################################################


################数据段###################
.data 
# 数据定义
num:		.word	000	    # 学号
strLen:		.word	10	    # 姓名字符串的最大长度

# 输出信息
NameMsg:	.string "请输入姓名："
NumMsg: 	.string "请输入学号："

################代码段###################
.text
# 输出NameMsg
la a0,NameMsg
li a7,4
ecall
# 把strLen加载到a1，调用系统调用功能8，输入字符串
lw a1,strLen
li a7,8
ecall
# 把a0内容放入t1寄存器
add t1,a0,zero              # t1 = a0 + 0
# 输出NumMsg
la a0,NumMsg
li a7,4
ecall
# 输入整数
li a7,5
ecall
sw a0,num,t2                # num = a0
# 输出输入的姓名字符串
add a0,t1,zero
li a7,4
ecall
# 输出ascii字符
addi a0,zero,10             # ascii 10 = '\n'
li a7,11
ecall
# 输出学号整数
lw a0,num
li a7,1
ecall
# exit退出
addi a7, zero, 10           # 系统调用,功能号为10。功能： 结束退出，即exit
ecall               	    # 系统调用命令